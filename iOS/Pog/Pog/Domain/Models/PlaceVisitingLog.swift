//
//  PlaceVisitingLog.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/31.
//

import Foundation


extension Place {
    public struct VisitingLog: Codable, Hashable {
        public var exitedAt: Date?
        public var visitedAt: Date
    }
}
