import Foundation
import CoreData
import Combine

public protocol Store {

    var logs: AnyPublisher<[PlaceLog], Never> { get }
    var context: NSManagedObjectContext { get }
}

public class StoreImpl {
    private let container = NSPersistentContainer(name: "Pog")

    private let placeLogSubject: CurrentValueSubject<[PlaceLog], Never> = .init([])

    public init(notificationCenter: NotificationCenter = .default) {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
            if let logs = try? self.container.viewContext.fetch(PlaceLog.fetchRequest()) {
                self.placeLogSubject.send(logs)
            }
        }
        notificationCenter.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: context,
            queue: .current
        ) { notification in
            if let added = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                let addedLogs = added.compactMap({ $0 as? PlaceLog })
                self.placeLogSubject.send(addedLogs)
            }
            if let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                let deletedLogs = deleted.compactMap({ $0 as? PlaceLog })
                var current = self.placeLogSubject.value
                current.removeAll(where: { placeLog in
                    deletedLogs.map(\.id).contains(placeLog.id)
                })
                self.placeLogSubject.send(current)
            }
        }
    }
}

extension StoreImpl: Store {

    public var logs: AnyPublisher<[PlaceLog], Never> {
        placeLogSubject.eraseToAnyPublisher()
    }

    public var context: NSManagedObjectContext {
        container.viewContext
    }
}
