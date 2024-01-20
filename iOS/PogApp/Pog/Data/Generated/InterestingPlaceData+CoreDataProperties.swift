//
//  InterestingPlaceData+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//
//

import CoreData
import Foundation

extension InterestingPlaceData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestingPlaceData> {
        return NSFetchRequest<InterestingPlaceData>(entityName: "InterestingPlaceData")
    }

    @NSManaged public var distanceMeter: Double
    @NSManaged public var icon: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var name: String?

}

extension InterestingPlaceData: Identifiable {

}
