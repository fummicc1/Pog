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
    var monitoringRegions: AnyPublisher<[CLRegion], Never> { get }
    var onEnterRegion: AnyPublisher<CLCircularRegion, Never> { get }
    var onExitRegion: AnyPublisher<CLCircularRegion, Never> { get }

    func request()
    func updateLocationManager<V>(keypath: ReferenceWritableKeyPath<CLLocationManager, V>, value: V)
    @discardableResult
    func startMonitoringRegion(id: String, at coordinate: CLLocationCoordinate2D, distance: Double) -> Bool
    @discardableResult
    func resignMonitoringRegion(at coordinate: CLLocationCoordinate2D) -> Bool
}

public class LocationManagerImpl: NSObject, CLLocationManagerDelegate, LocationManager {

    // MARK: Private Properties
    private let onEnterRegionSubject: PassthroughSubject<CLRegion, Never> = .init()
    private let onExitRegionSubject: PassthroughSubject<CLRegion, Never> = .init()
    private let monitoringRegionsSubject: CurrentValueSubject<[CLRegion], Never> = .init([])
    private let coordinateSubject: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    private let errorSubject: PassthroughSubject<Error, Never> = .init()
    private let authorizationStatusRelay: CurrentValueSubject<CLAuthorizationStatus, Never> = .init(.notDetermined)
    private let isAuthorizedForPreciseLocationSubject: CurrentValueSubject<Bool, Never> = .init(false)

    private var prepareForRequestAlways: Bool = false
    private let manager = CLLocationManager()

    // MARK: Public Properties
    public var currentCoordinate: CLLocationCoordinate2D? {
        coordinateSubject.value
    }
    public var coordinate: AnyPublisher<CLLocationCoordinate2D, Never> {
        coordinateSubject.compactMap({ $0 }).eraseToAnyPublisher()
    }
    public var error: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    public var currentAuthorizationStatus: CLAuthorizationStatus {
        authorizationStatusRelay.value
    }
    public var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusRelay.eraseToAnyPublisher()
    }
    public var isAuthorizedForPreciseLocation: AnyPublisher<Bool, Never> {
        isAuthorizedForPreciseLocationSubject.eraseToAnyPublisher()
    }
    public var allowsBackgroundLocationUpdates: Bool {
        manager.allowsBackgroundLocationUpdates
    }
    public var monitoringRegions: AnyPublisher<[CLRegion], Never> {
        monitoringRegionsSubject.eraseToAnyPublisher()
    }
    public var onEnterRegion: AnyPublisher<CLCircularRegion, Never> {
        onEnterRegionSubject
            .compactMap({ $0 as? CLCircularRegion })
            .eraseToAnyPublisher()
    }
    public var onExitRegion: AnyPublisher<CLCircularRegion, Never> {
        onExitRegionSubject
            .compactMap({ $0 as? CLCircularRegion })
            .eraseToAnyPublisher()
    }

    public static let shared: LocationManagerImpl = .init()

    // MARK: Methods
    public override init() {
        super.init()
        manager.showsBackgroundLocationIndicator = true
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 30
        manager.delegate = self
        let monitoringRegions = manager.monitoredRegions.map({ $0 })
        monitoringRegionsSubject.send(monitoringRegions)
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

    public func startMonitoringRegion(id: String, at coordinate: CLLocationCoordinate2D, distance: Double) -> Bool {
        let regions = manager.monitoredRegions.compactMap({ $0 as? CLCircularRegion })
        if regions.map(\.center).contains(coordinate) {
            return false
        }
        let region = CLCircularRegion(
            center: coordinate,
            radius: distance,
            identifier: id
        )
        monitoringRegionsSubject.send(
            monitoringRegionsSubject.value + [region]
        )
        manager.startMonitoring(for: region)
        return true
    }

    public func resignMonitoringRegion(at coordinate: CLLocationCoordinate2D) -> Bool {
        let regions = manager.monitoredRegions.compactMap({ $0 as? CLCircularRegion })
        for region in regions {
            if region.center == coordinate {
                manager.stopMonitoring(for: region)
                var regions = monitoringRegionsSubject
                    .value
                    .compactMap({ $0 as? CLCircularRegion })
                regions.removeAll(where: { $0.center == coordinate })
                monitoringRegionsSubject.send(regions)
                return true
            }
        }
        return false
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorSubject.send(error)
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatusRelay.send(manager.authorizationStatus)

        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            self.isAuthorizedForPreciseLocationSubject.send(true)
        case .reducedAccuracy:
            self.isAuthorizedForPreciseLocationSubject.send(false)
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
            coordinateSubject.send(location.coordinate)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        onEnterRegionSubject.send(region)
    }

    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        onExitRegionSubject.send(region)
    }
}
