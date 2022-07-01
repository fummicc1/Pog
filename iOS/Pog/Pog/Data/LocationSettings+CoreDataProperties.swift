//
//  LocationSettings+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/01.
//
//

import Foundation
import CoreData


extension LocationSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationSettings> {
        return NSFetchRequest<LocationSettings>(entityName: "LocationSettings")
    }

    @NSManaged public var allowsBackgroundLocationUpdates: Bool
    @NSManaged public var distanceFilter: Double
    @NSManaged public var pausesLocationUpdatesAutomatically: Bool
    @NSManaged public var transportService: TransportService?

}

extension LocationSettings : Identifiable {

}
