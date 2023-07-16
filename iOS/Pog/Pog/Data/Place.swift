//
//  Place.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import CoreLocation
import Foundation

public struct Place: Identifiable, Hashable {
    public let lat: CLLocationDegrees
    public let lng: CLLocationDegrees
    public var icon: String?

    public let name: String

    public var id: String {
        return "\(lat)/\(lng)"
    }
}

extension PlaceLogData {
    func roundCoordinate() {
        self.lat = Double(Int(self.lat * 100_000)) / 100_000
        self.lng = Double(Int(self.lng * 100_000)) / 100_000
    }
}
