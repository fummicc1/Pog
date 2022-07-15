///
/// @Generated by Mockolo
///



import Combine
import CoreData
import CoreLocation
import Foundation
import MapKit
import Moya


public class PlaceManagerMock: PlaceManager {
    public init() { }
    public init(places: [Place] = [Place]()) {
        self.places = places
    }


    public var placesPublisher: AnyPublisher<[Place], Never> { return self.placesPublisherSubject.eraseToAnyPublisher() }
    public private(set) var placesPublisherSubject = PassthroughSubject<[Place], Never>()

    public private(set) var placesSetCallCount = 0
    public var places: [Place] = [Place]() { didSet { placesSetCallCount += 1 } }

    public var error: AnyPublisher<Error, Never> { return self.errorSubject.eraseToAnyPublisher() }
    public private(set) var errorSubject = PassthroughSubject<Error, Never>()

    public private(set) var searchNearbyCallCount = 0
    public var searchNearbyHandler: ((CLLocationCoordinate2D) -> ())?
    public func searchNearby(at coordinate: CLLocationCoordinate2D)  {
        searchNearbyCallCount += 1
        if let searchNearbyHandler = searchNearbyHandler {
            searchNearbyHandler(coordinate)
        }
        
    }

    public private(set) var searchCallCount = 0
    public var searchHandler: ((String, CLLocationCoordinate2D?, Bool) async -> ())?
    public func search(text: String, at coordinate: CLLocationCoordinate2D?, useGooglePlaces: Bool) async  {
        searchCallCount += 1
        if let searchHandler = searchHandler {
            await searchHandler(text, coordinate, useGooglePlaces)
        }
        
    }
}

public class LocationManagerMock: LocationManager {
    public init() { }
    public init(allowsBackgroundLocationUpdates: Bool = false, currentCoordinate: CLLocationCoordinate2D? = nil, currentAuthorizationStatus: CLAuthorizationStatus) {
        self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        self.currentCoordinate = currentCoordinate
        self._currentAuthorizationStatus = currentAuthorizationStatus
    }


    public var isAuthorizedForPreciseLocation: AnyPublisher<Bool, Never> { return self.isAuthorizedForPreciseLocationSubject.eraseToAnyPublisher() }
    public private(set) var isAuthorizedForPreciseLocationSubject = PassthroughSubject<Bool, Never>()

    public private(set) var allowsBackgroundLocationUpdatesSetCallCount = 0
    public var allowsBackgroundLocationUpdates: Bool = false { didSet { allowsBackgroundLocationUpdatesSetCallCount += 1 } }

    public private(set) var currentCoordinateSetCallCount = 0
    public var currentCoordinate: CLLocationCoordinate2D? = nil { didSet { currentCoordinateSetCallCount += 1 } }

    public var coordinate: AnyPublisher<CLLocationCoordinate2D, Never> { return self.coordinateSubject.eraseToAnyPublisher() }
    public private(set) var coordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()

    public private(set) var currentAuthorizationStatusSetCallCount = 0
    private var _currentAuthorizationStatus: CLAuthorizationStatus!  { didSet { currentAuthorizationStatusSetCallCount += 1 } }
    public var currentAuthorizationStatus: CLAuthorizationStatus {
        get { return _currentAuthorizationStatus }
        set { _currentAuthorizationStatus = newValue }
    }

    public var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { return self.authorizationStatusSubject.eraseToAnyPublisher() }
    public private(set) var authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()

    public var error: AnyPublisher<Error, Never> { return self.errorSubject.eraseToAnyPublisher() }
    public private(set) var errorSubject = PassthroughSubject<Error, Never>()

    public var monitoringRegions: AnyPublisher<[CLRegion], Never> { return self.monitoringRegionsSubject.eraseToAnyPublisher() }
    public private(set) var monitoringRegionsSubject = PassthroughSubject<[CLRegion], Never>()

    public var onEnterRegion: AnyPublisher<CLCircularRegion, Never> { return self.onEnterRegionSubject.eraseToAnyPublisher() }
    public private(set) var onEnterRegionSubject = PassthroughSubject<CLCircularRegion, Never>()

    public var onExitRegion: AnyPublisher<CLCircularRegion, Never> { return self.onExitRegionSubject.eraseToAnyPublisher() }
    public private(set) var onExitRegionSubject = PassthroughSubject<CLCircularRegion, Never>()

    public private(set) var requestCallCount = 0
    public var requestHandler: (() -> ())?
    public func request()  {
        requestCallCount += 1
        if let requestHandler = requestHandler {
            requestHandler()
        }
        
    }

    public private(set) var updateLocationManagerCallCount = 0
    public var updateLocationManagerHandler: ((Any, Any) -> ())?
    public func updateLocationManager<V>(keypath: ReferenceWritableKeyPath<CLLocationManager, V>, value: V)  {
        updateLocationManagerCallCount += 1
        if let updateLocationManagerHandler = updateLocationManagerHandler {
            updateLocationManagerHandler(keypath, value)
        }
        
    }

    public private(set) var startMonitoringRegionCallCount = 0
    public var startMonitoringRegionHandler: ((String, CLLocationCoordinate2D, Double) -> (Bool))?
    public func startMonitoringRegion(id: String, at coordinate: CLLocationCoordinate2D, distance: Double) -> Bool {
        startMonitoringRegionCallCount += 1
        if let startMonitoringRegionHandler = startMonitoringRegionHandler {
            return startMonitoringRegionHandler(id, coordinate, distance)
        }
        return false
    }

    public private(set) var resignMonitoringRegionCallCount = 0
    public var resignMonitoringRegionHandler: ((CLLocationCoordinate2D) -> (Bool))?
    public func resignMonitoringRegion(at coordinate: CLLocationCoordinate2D) -> Bool {
        resignMonitoringRegionCallCount += 1
        if let resignMonitoringRegionHandler = resignMonitoringRegionHandler {
            return resignMonitoringRegionHandler(coordinate)
        }
        return false
    }
}

