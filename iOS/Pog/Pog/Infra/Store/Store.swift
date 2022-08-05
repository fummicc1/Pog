//
//  Store.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/31.
//

import Foundation
import CoreData
import Combine

/// @mockable
public protocol Store {
    var logs: AnyPublisher<[UserLocationLog], Never> { get }
    var interestingPlaceVisitingLogs: AnyPublisher<[InterestingPlaceVisitingLog], Never> { get }
    var interestingPlaces: AnyPublisher<[InterestingPlace], Never> { get }
    var locationSettings: AnyPublisher<LocationSettings?, Never> { get }
    var context: NSManagedObjectContext { get }

    func deleteWithBatch(_ request: NSBatchDeleteRequest) throws
    func fetch<Obj: NSManagedObject>(type: Obj.Type) throws -> [Obj]

    func observeUserDefaults<Value>(keypath: KeyPath<UserDefaults, Value>, onChange: @escaping (Value) -> Void) -> NSKeyValueObservation
    func updateUserDefaults<Value>(key: UserDefaultsKey, value: Value)
}


public class StoreImpl {

    private let container = NSPersistentContainer(name: "Pog")

    private let userDefaults: UserDefaults = UserDefaults(suiteName: "group.fummicc1.pog")!

    private let interestingPlaceVisitingLogsSubject: CurrentValueSubject<[InterestingPlaceVisitingLog], Never> = .init([])
    private let userLocationLogSubject: CurrentValueSubject<[UserLocationLog], Never> = .init([])
    private let interestingPlacesSubject: CurrentValueSubject<[InterestingPlace], Never> = .init([])
    private let locationSettingsSubject: CurrentValueSubject<LocationSettings?, Never> = .init(nil)

    private let que: DispatchQueue = .init(label: "dev.fummicc1.Pog.ios.store")

    private static var numberOfInit: Int = 0
    private static var currentCoreDataModelVersion: Int = 9
    private static var currentCoreDataStoreURL: URL? = {
        guard let url = Bundle.main.url(forResource: "Pog \(currentCoreDataModelVersion)", withExtension: "mom", subdirectory: "Pog.momd") else {
            assertionFailure("Pog.mom file does not exists.")
            return nil
        }
        return url
    }()

    public init(notificationCenter: NotificationCenter = .default) {
        Self.numberOfInit += 1
        assert(Self.numberOfInit == 1)
        que.async {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            do {
                if let currentCoreDataStoreURL = Self.currentCoreDataStoreURL {
                    try self.container.persistentStoreCoordinator.addPersistentStore(
                        ofType: NSSQLiteStoreType,
                        configurationName: nil,
                        at: currentCoreDataStoreURL,
                        options: options
                    )
                }
                self.container.loadPersistentStores { _, error in
                    if let error = error {
                        print(error)
                    }
                    if let logs = try? self.container.viewContext.fetch(UserLocationLog.fetchRequest()) {
                        self.userLocationLogSubject.send(logs)
                    }
                    if let places = try? self.container.viewContext.fetch(InterestingPlace.fetchRequest()) {
                        self.interestingPlacesSubject.send(places)
                    }
                    if let locationSettings = try? self.container.viewContext.fetch(LocationSettings.fetchRequest()) {
                        if !locationSettings.isEmpty {
                            assert(locationSettings.count == 1)
                            self.locationSettingsSubject.send(locationSettings.last!)
                        }
                    }
                    if let visitingLogs = try? self.container.viewContext.fetch(InterestingPlaceVisitingLog.fetchRequest()) {
                        self.interestingPlaceVisitingLogsSubject.send(visitingLogs)
                    }
                }

                notificationCenter.addObserver(
                    forName: .NSManagedObjectContextObjectsDidChange,
                    object: self.context,
                    queue: nil
                ) { notification in
                    if let added = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                        var addedLogs: [UserLocationLog] = []
                        var addedPlaces: [InterestingPlace] = []
                        var addedLocationSettings: LocationSettings?
                        var addedVisitingLogs: [InterestingPlaceVisitingLog] = []

                        for obj in added {
                            if let log = obj as? UserLocationLog {
                                addedLogs.append(log)
                            }
                            if let place = obj as? InterestingPlace {
                                addedPlaces.append(place)
                            }
                            if let locationSettings = obj as? LocationSettings {
                                addedLocationSettings = locationSettings
                            }
                            if let visitingLog = obj as? InterestingPlaceVisitingLog {
                                addedVisitingLogs.append(visitingLog)
                            }
                        }

                        _ = {
                            let all = self.userLocationLogSubject.value + addedLogs
                            self.userLocationLogSubject.send(all)
                        }()
                        _ = {
                            let all = self.interestingPlacesSubject.value + addedPlaces
                            self.interestingPlacesSubject.send(all)
                        }()
                        _ = {
                            self.locationSettingsSubject.send(addedLocationSettings)
                        }()
                        _ = {
                            let all = self.interestingPlaceVisitingLogsSubject.value + addedVisitingLogs
                            self.interestingPlaceVisitingLogsSubject.send(all)
                        }()
                    }
                    if let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                        var deletedLogs: [UserLocationLog] = []
                        var deletedPlaces: [InterestingPlace] = []
                        var isDeletedLocationSettings: Bool = false

                        for obj in deleted {
                            if let log = obj as? UserLocationLog {
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
                            var current = self.userLocationLogSubject.value
                            current.removeAll(where: { userLocationLog in
                                deletedLogs.map(\.id).contains(userLocationLog.id)
                            })
                            self.userLocationLogSubject.send(current)
                        }()
                        _ = {
                            if isDeletedLocationSettings {
                                self.locationSettingsSubject.send(nil)
                            }
                        }()
                    }
                    if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                        var updatedLocationSettings: LocationSettings?
                        var updatedInterestingPlaceVisitingLogs: [InterestingPlaceVisitingLog] = []
                        for obj in updated {
                            if let locationSettings = obj as? LocationSettings {
                                updatedLocationSettings = locationSettings
                            }
                            if let visitingLog = obj as? InterestingPlaceVisitingLog {
                                updatedInterestingPlaceVisitingLogs.append(visitingLog)
                            }
                        }
                        if let updatedLocationSettings = updatedLocationSettings {
                            self.locationSettingsSubject.send(updatedLocationSettings)
                        }
                        let newInterestingPlaceVisitingLogs = Set(
                            updatedInterestingPlaceVisitingLogs + self.interestingPlaceVisitingLogsSubject.value
                        ).map { $0 }
                        self.interestingPlaceVisitingLogsSubject.send(newInterestingPlaceVisitingLogs)
                    }
                }
            } catch {
                fatalError("Failed to add persistent store: \(error)")
            }
        }
    }
}

extension StoreImpl: Store {

    public var interestingPlaces: AnyPublisher<[InterestingPlace], Never> {
        interestingPlacesSubject.share().eraseToAnyPublisher()
    }

    public var logs: AnyPublisher<[UserLocationLog], Never> {
        userLocationLogSubject.share().eraseToAnyPublisher()
    }

    public var locationSettings: AnyPublisher<LocationSettings?, Never> {
        locationSettingsSubject.share().eraseToAnyPublisher()
    }

    public var interestingPlaceVisitingLogs: AnyPublisher<[InterestingPlaceVisitingLog], Never> {
        interestingPlaceVisitingLogsSubject.eraseToAnyPublisher()
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

    public func updateUserDefaults<Value>(key: UserDefaultsKey, value: Value) {
        userDefaults.set(value, forKey: key.key)
    }

    public func observeUserDefaults<Value>(
        keypath: KeyPath<UserDefaults, Value>,
        onChange: @escaping (Value) -> Void
    ) -> NSKeyValueObservation {
        let observation = userDefaults.observe(keypath, options: [.new, .initial]) { _, changes in
            if let new = changes.newValue {
                onChange(new)
            }
        }
        return observation
    }
}
