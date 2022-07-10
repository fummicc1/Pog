//
//  InterestingPlaceVisitingLog+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/10.
//
//

import Foundation
import CoreData


extension InterestingPlaceVisitingLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestingPlaceVisitingLog> {
        return NSFetchRequest<InterestingPlaceVisitingLog>(entityName: "InterestingPlaceVisitingLog")
    }

    @NSManaged public var visitedAt: Date?
    @NSManaged public var exitedAt: Date?
    @NSManaged public var place: InterestingPlace?

}

extension InterestingPlaceVisitingLog : Identifiable {

}
