//
//  LocationManager.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Combine
import Foundation
import CoreLocation

public protocol LocationManager {
    var currentCoordinate: CLLocationCoordinate2D? { get }
    var coordinate: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { get }
    var error: AnyPublisher<Error, Never> { get }

    func request()
}

public class LocationManagerImpl: NSObject, CLLocationManagerDelegate, LocationManager {

    private let coordinateRelay: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    private let errorRelay: PassthroughSubject<Error, Never> = .init()
    private let authorizationStatusRelay: PassthroughSubject<CLAuthorizationStatus, Never> = .init()
    private var prepareForRequestAlways: Bool = false
    private let manager = CLLocationManager()

    public var currentCoordinate: CLLocationCoordinate2D? {
        coordinateRelay.value
    }
    public var coordinate: AnyPublisher<CLLocationCoordinate2D, Never> {
        coordinateRelay.compactMap({ $0 }).eraseToAnyPublisher()
    }
    public var error: AnyPublisher<Error, Never> {
        errorRelay.eraseToAnyPublisher()
    }
    public var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusRelay.eraseToAnyPublisher()
    }

    public static let shared: LocationManagerImpl = .init()

    public override init() {
        super.init()
        manager.showsBackgroundLocationIndicator = true
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 30
        manager.delegate = self
    }

    public func request() {
        manager.requestAlwaysAuthorization()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorRelay.send(error)
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            return
        }
        authorizationStatusRelay.send(manager.authorizationStatus)

        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startMonitoringSignificantLocationChanges()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coordinateRelay.send(location.coordinate)
        }
    }
}
