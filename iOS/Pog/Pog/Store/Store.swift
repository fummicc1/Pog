import Foundation
import CoreData
import Combine

public protocol Store {

    var logs: AnyPublisher<[PlaceLog], Never> { get }
    var interestingPlaces: AnyPublisher<[InterestingPlace], Never> { get }
    var context: NSManagedObjectContext { get }
}

public class StoreImpl {

    public static let shared: Store = StoreImpl()

    private let container = NSPersistentContainer(name: "Pog")

    private let placeLogSubject: CurrentValueSubject<[PlaceLog], Never> = .init([])
    private let interestingPlacesSubject: CurrentValueSubject<[InterestingPlace], Never> = .init([])

    private init(notificationCenter: NotificationCenter = .default) {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
            if let logs = try? self.container.viewContext.fetch(PlaceLog.fetchRequest()) {
                self.placeLogSubject.send(logs)
            }
            if let places = try? self.container.viewContext.fetch(InterestingPlace.fetchRequest()) {
                self.interestingPlacesSubject.send(places)
            }
        }
        notificationCenter.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: context,
            queue: nil
        ) { notification in
            if let added = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                var addedLogs: [PlaceLog] = []
                var addedPlaces: [InterestingPlace] = []

                for obj in added {
                    if let log = obj as? PlaceLog {
                        addedLogs.append(log)
                    }
                    if let place = obj as? InterestingPlace {
                        addedPlaces.append(place)
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
            }
            if let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                var deletedLogs: [PlaceLog] = []
                var deletedPlaces: [InterestingPlace] = []

                for obj in deleted {
                    if let log = obj as? PlaceLog {
                        deletedLogs.append(log)
                    }
                    if let place = obj as? InterestingPlace {
                        deletedPlaces.append(place)
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
            }
        }
    }
}

extension StoreImpl: Store {

    public var interestingPlaces: AnyPublisher<[InterestingPlace], Never> {
        interestingPlacesSubject.eraseToAnyPublisher()
    }

    public var logs: AnyPublisher<[PlaceLog], Never> {
        placeLogSubject.eraseToAnyPublisher()
    }

    public var context: NSManagedObjectContext {
        container.viewContext

    }
}
