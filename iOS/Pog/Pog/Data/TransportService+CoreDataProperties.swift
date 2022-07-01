//
//  TransportService+CoreDataProperties.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/01.
//
//

import Foundation
import CoreData


extension TransportService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransportService> {
        return NSFetchRequest<TransportService>(entityName: "TransportService")
    }

    @NSManaged public var rawValue: Int16

}

extension TransportService : Identifiable {

}
