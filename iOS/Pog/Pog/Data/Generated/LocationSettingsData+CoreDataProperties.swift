//
//  LocationSettingsData+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//
//

import Foundation
import CoreData


extension LocationSettingsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationSettingsData> {
        return NSFetchRequest<LocationSettingsData>(entityName: "LocationSettingsData")
    }

    @NSManaged public var allowsBackgroundLocationUpdates: Bool
    @NSManaged public var desiredAccuracy: Double
    @NSManaged public var distanceFilter: Double
    @NSManaged public var pausesLocationUpdatesAutomatically: Bool

}

extension LocationSettingsData : Identifiable {

}
