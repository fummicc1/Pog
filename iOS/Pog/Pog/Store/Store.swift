import Foundation
import CoreData
import Combine

public protocol Store {
    var searchedWords: AnyPublisher<[String], Never> { get }
    var logs: AnyPublisher<[PlaceLog], Never> { get }
    var interestingPlaces: AnyPublisher<[InterestingPlace], Never> { get }
    var locationSettings: AnyPublisher<LocationSettings?, Never> { get }
    var context: NSManagedObjectContext { get }
    var userDefaults: UserDefaults { get }

    func deleteWithBatch(_ request: NSBatchDeleteRequest) throws
    func fetch<Obj: NSManagedObject>(type: Obj.Type) throws -> [Obj]
}

extension Const {
    public enum UserDefaults {
        static let searchedWords = "searchedWords"
    }
}

public class StoreImpl {

    private let container = NSPersistentContainer(name: "Pog")

    public let userDefaults: UserDefaults = UserDefaults(suiteName: "group.fummicc1.pog")!

    private let placeLogSubject: CurrentValueSubject<[PlaceLog], Never> = .init([])
    private let interestingPlacesSubject: CurrentValueSubject<[InterestingPlace], Never> = .init([])
    private let locationSettingsSubject: CurrentValueSubject<LocationSettings?, Never> = .init(nil)

    private var keyObservers: [NSKeyValueObservation] = []

    private let searchedWordsSubject: CurrentValueSubject<[String], Never> = .init([])

    public init(notificationCenter: NotificationCenter = .default) {
        DispatchQueue.global().async {
            let observation = self.userDefaults.observe(\.searchedWords, options: [.initial, .new]) { _, change in
                if let new = change.newValue {
                    self.searchedWordsSubject.send(new)
                }
            }
            self.keyObservers.append(observation)
            self.container.loadPersistentStores { _, error in
                if let error = error {
                    print(error)
                }
                if let logs = try? self.container.viewContext.fetch(PlaceLog.fetchRequest()) {
                    self.placeLogSubject.send(logs)
                }
                if let places = try? self.container.viewContext.fetch(InterestingPlace.fetchRequest()) {
                    self.interestingPlacesSubject.send(places)
                }
                if let locationSettings = try? self.container.viewContext.fetch(LocationSettings.fetchRequest()) {
                    if locationSettings.isEmpty {
                        return
                    }
                    assert(locationSettings.count == 1)
                    self.locationSettingsSubject.send(locationSettings.last!)
                }
            }

            notificationCenter.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: self.context,
                queue: nil
            ) { notification in
                if let added = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                    var addedLogs: [PlaceLog] = []
                    var addedPlaces: [InterestingPlace] = []
                    var addedLocationSettings: LocationSettings?

                    for obj in added {
                        if let log = obj as? PlaceLog {
                            addedLogs.append(log)
                        }
                        if let place = obj as? InterestingPlace {
                            addedPlaces.append(place)
                        }
                        if let locationSettings = obj as? LocationSettings {
                            addedLocationSettings = locationSettings
                        }
                    }

                    _ = {
                        let all = self.placeLogSubject.value + addedLogs
                        self.placeLogSubject.send(all)
                    }()
                    _ = {
                        let all = self.interestingPlacesSubject.value + addedPlaces
                        self.interestingPlacesSubject.send(all)
                    }()
                    _ = {
                        self.locationSettingsSubject.send(addedLocationSettings)
                    }()
                }
                if let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                    var deletedLogs: [PlaceLog] = []
                    var deletedPlaces: [InterestingPlace] = []
                    var isDeletedLocationSettings: Bool = false

                    for obj in deleted {
                        if let log = obj as? PlaceLog {
                            deletedLogs.append(log)
                        }
                        if let place = obj as? InterestingPlace {
                            deletedPlaces.append(place)
                        }
                        if obj is LocationSettings {
                            isDeletedLocationSettings = true
                        }
                    }

                    _ = {
                        var current = self.interestingPlacesSubject.value
                        current.removeAll(where: { place in
                            deletedPlaces.map(\.id).contains(place.id)
                        })
                        self.interestingPlacesSubject.send(current)
                    }()
                    _ = {
                        var current = self.placeLogSubject.value
                        current.removeAll(where: { placeLog in
                            deletedLogs.map(\.id).contains(placeLog.id)
                        })
                        self.placeLogSubject.send(current)
                    }()
                    _ = {
                        if isDeletedLocationSettings {
                            self.locationSettingsSubject.send(nil)
                        }
                    }()
                }
                if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                    var updatedLocationSettings: LocationSettings?
                    for obj in updated {
                        if let locationSettings = obj as? LocationSettings {
                            updatedLocationSettings = locationSettings
                        }
                    }
                    if let updatedLocationSettings = updatedLocationSettings {
                        self.locationSettingsSubject.send(updatedLocationSettings)
                    }
                }
            }
        }
    }

    deinit {
        keyObservers.forEach { $0.invalidate() }
    }
}

extension StoreImpl: Store {

    public var searchedWords: AnyPublisher<[String], Never> {
        searchedWordsSubject.share().eraseToAnyPublisher()
    }

    public var interestingPlaces: AnyPublisher<[InterestingPlace], Never> {
        interestingPlacesSubject.share().eraseToAnyPublisher()
    }

    public var logs: AnyPublisher<[PlaceLog], Never> {
        placeLogSubject.share().eraseToAnyPublisher()
    }

    public var locationSettings: AnyPublisher<LocationSettings?, Never> {
        locationSettingsSubject.share().eraseToAnyPublisher()
    }

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public func deleteWithBatch(_ request: NSBatchDeleteRequest) throws {
        request.resultType = .resultTypeObjectIDs
        let batchResult = try context.execute(request) as? NSBatchDeleteResult
        guard let deleteResult = batchResult?.result as? [NSManagedObjectID] else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }

    public func fetch<Obj>(type: Obj.Type) throws -> [Obj] where Obj : NSManagedObject {
        let request = Obj.fetchRequest()
        return try context.fetch(request) as? [Obj] ?? []
    }
}


// MARK: UserDefaults Observation
extension UserDefaults {
    @objc public dynamic var searchedWords: [String] {
        return array(forKey: Const.UserDefaults.searchedWords) as? [String] ?? []
    }
}
