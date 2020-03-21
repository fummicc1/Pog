//
//  LocatiionManager.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    let locationManager: CLLocationManager
}
