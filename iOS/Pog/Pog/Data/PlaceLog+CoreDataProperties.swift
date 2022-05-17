//
//  PlaceLog+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//
//

import Foundation
import CoreData


extension PlaceLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceLog> {
        return NSFetchRequest<PlaceLog>(entityName: "PlaceLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}

extension PlaceLog : Identifiable {

}
