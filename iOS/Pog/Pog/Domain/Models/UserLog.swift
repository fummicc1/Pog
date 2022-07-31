//
//  UserLog.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/31.
//

import Foundation


extension Model {
    public struct UserLog: Codable {
        public var color: String?
        public var lat: Double
        public var lng: Double
        public var date: Date
        public var memo: String?

        public init(color: String? = nil, lat: Double, lng: Double, date: Date, memo: String? = nil) {
            self.color = color
            self.lat = lat
            self.lng = lng
            self.date = date
            self.memo = memo
        }
    }
}
