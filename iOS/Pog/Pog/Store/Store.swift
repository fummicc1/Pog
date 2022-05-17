//
//  Store.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Foundation
import CoreData

public protocol Store {

    var context: NSManagedObjectContext { get }

    func save() throws
}

public class StoreImpl {
    private let container = NSPersistentContainer(name: "Pog")

    public init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
        }
    }
}

extension StoreImpl: Store {

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public func save() throws {
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
    }

}
