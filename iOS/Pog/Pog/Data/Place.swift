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
