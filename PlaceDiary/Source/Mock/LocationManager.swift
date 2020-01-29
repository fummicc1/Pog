//
//  LocationManager.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import CoreLocation

protocol LocationManager {
	var delegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: LocationManager {}


class LocationManagerMock: LocationManager {
	var delegate: CLLocationManagerDelegate?
}
