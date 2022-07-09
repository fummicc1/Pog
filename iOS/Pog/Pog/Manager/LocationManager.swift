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
    var isAuthorizedForPreciseLocation: AnyPublisher<Bool, Never> { get }
    var allowsBackgroundLocationUpdates: Bool { get }
    var currentCoordinate: CLLocationCoordinate2D? { get }
    var coordinate: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var currentAuthorizationStatus: CLAuthorizationStatus { get }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { get }
    var error: AnyPublisher<Error, Never> { get }

    func request()
    func updateLocationManager<V>(keypath: ReferenceWritableKeyPath<CLLocationManager, V>, value: V)
}

public class LocationManagerImpl: NSObject, CLLocationManagerDelegate, LocationManager {

    private let coordinateRelay: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    private let errorRelay: PassthroughSubject<Error, Never> = .init()
    private let authorizationStatusRelay: CurrentValueSubject<CLAuthorizationStatus, Never> = .init(.notDetermined)
    private let isAuthorizedForPreciseLocationRelay: CurrentValueSubject<Bool, Never> = .init(false)
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
    public var currentAuthorizationStatus: CLAuthorizationStatus {
        authorizationStatusRelay.value
    }
    public var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusRelay.eraseToAnyPublisher()
    }
    public var isAuthorizedForPreciseLocation: AnyPublisher<Bool, Never> {
        isAuthorizedForPreciseLocationRelay.eraseToAnyPublisher()
    }
    public var allowsBackgroundLocationUpdates: Bool {
        manager.allowsBackgroundLocationUpdates
    }

    public static let shared: LocationManagerImpl = .init()

    public override init() {
        super.init()
        manager.showsBackgroundLocationIndicator = true
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 30
        manager.delegate = self
    }

    public func updateLocationManager<V>(keypath: ReferenceWritableKeyPath<CLLocationManager, V>, value: V) {
        manager[keyPath: keypath] = value

        // Perform side-effects for changes
        if keypath == \CLLocationManager.allowsBackgroundLocationUpdates {
            if manager.allowsBackgroundLocationUpdates {
                manager.startMonitoringSignificantLocationChanges()
            } else {
                manager.stopMonitoringSignificantLocationChanges()
            }
        }
    }

    public func request() {
        manager.requestWhenInUseAuthorization()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorRelay.send(error)
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatusRelay.send(manager.authorizationStatus)

        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            self.isAuthorizedForPreciseLocationRelay.send(true)
        case .reducedAccuracy:
            self.isAuthorizedForPreciseLocationRelay.send(false)
        @unknown default:
            assertionFailure()
            break
        }

        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            coordinateRelay.send(location.coordinate)
        }
    }
}
