//
//  InterestingPlace+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/05.
//
//

import Foundation
import CoreData


extension InterestingPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestingPlace> {
        return NSFetchRequest<InterestingPlace>(entityName: "InterestingPlace")
    }

    @NSManaged public var distanceMeter: Double
    @NSManaged public var icon: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var name: String?

}

extension InterestingPlace : Identifiable {

}
