//
//  LocationSettings+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/05.
//
//

import Foundation
import CoreData


extension LocationSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationSettings> {
        return NSFetchRequest<LocationSettings>(entityName: "LocationSettings")
    }

    @NSManaged public var allowsBackgroundLocationUpdates: Bool
    @NSManaged public var desiredAccuracy: Double
    @NSManaged public var distanceFilter: Double
    @NSManaged public var pausesLocationUpdatesAutomatically: Bool

}

extension LocationSettings : Identifiable {

}
