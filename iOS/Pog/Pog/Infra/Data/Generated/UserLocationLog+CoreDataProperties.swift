//
//  UserLocationLog+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/05.
//
//

import Foundation
import CoreData


extension UserLocationLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocationLog> {
        return NSFetchRequest<UserLocationLog>(entityName: "UserLocationLog")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var memo: String?

}

extension UserLocationLog : Identifiable {

}
