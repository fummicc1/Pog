//
//  InterestingPlaceVisitingLogData+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/08/18.
//
//

import Foundation
import CoreData


extension InterestingPlaceVisitingLogData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestingPlaceVisitingLogData> {
        return NSFetchRequest<InterestingPlaceVisitingLogData>(entityName: "InterestingPlaceVisitingLogData")
    }

    @NSManaged public var exitedAt: Date?
    @NSManaged public var visitedAt: Date?
    @NSManaged public var place: InterestingPlaceData?

}

extension InterestingPlaceVisitingLogData : Identifiable {

}
