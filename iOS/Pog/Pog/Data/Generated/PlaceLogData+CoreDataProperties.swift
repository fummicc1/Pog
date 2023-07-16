//
//  PlaceLogData+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//
//

import CoreData
import Foundation

extension PlaceLogData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceLogData> {
        return NSFetchRequest<PlaceLogData>(entityName: "PlaceLogData")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var memo: String?

}

extension PlaceLogData: Identifiable {

}
