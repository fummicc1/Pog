///
/// @Generated by Mockolo
///



import Combine
import CoreData
import CoreLocation
import Foundation
import MapKit
import Moya


public class StoreMock: Store {
    public init() { }
    public init(context: NSManagedObjectContext) {
        self._context = context
    }


    public var searchConfiguration: AnyPublisher<SearchConfiguration, Never> { return self.searchConfigurationSubject.eraseToAnyPublisher() }
    public private(set) var searchConfigurationSubject = PassthroughSubject<SearchConfiguration, Never>()

    public var logs: AnyPublisher<[PlaceLogData], Never> { return self.logsSubject.eraseToAnyPublisher() }
    public private(set) var logsSubject = PassthroughSubject<[PlaceLogData], Never>()

    public var interestingPlaceVisitingLogDatas: AnyPublisher<[InterestingPlaceVisitingLogData], Never> { return self.interestingPlaceVisitingLogDatasSubject.eraseToAnyPublisher() }
    public private(set) var interestingPlaceVisitingLogDatasSubject = PassthroughSubject<[InterestingPlaceVisitingLogData], Never>()

    public var interestingPlaces: AnyPublisher<[InterestingPlaceData], Never> { return self.interestingPlacesSubject.eraseToAnyPublisher() }
    public private(set) var interestingPlacesSubject = PassthroughSubject<[InterestingPlaceData], Never>()

    public var locationSettings: AnyPublisher<LocationSettingsData?, Never> { return self.locationSettingsSubject.eraseToAnyPublisher() }
    public private(set) var locationSettingsSubject = PassthroughSubject<LocationSettingsData?, Never>()

    public private(set) var contextSetCallCount = 0
    private var _context: NSManagedObjectContext!  { didSet { contextSetCallCount += 1 } }
    public var context: NSManagedObjectContext {
        get { return _context }
        set { _context = newValue }
    }

    public private(set) var deleteWithBatchCallCount = 0
    public var deleteWithBatchHandler: ((NSBatchDeleteRequest) throws -> ())?
    public func deleteWithBatch(_ request: NSBatchDeleteRequest) throws  {
        deleteWithBatchCallCount += 1
        if let deleteWithBatchHandler = deleteWithBatchHandler {
            try deleteWithBatchHandler(request)
        }
        
    }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((Any) throws -> (Any))?
    public func fetch<Obj: NSManagedObject>(type: Obj.Type) throws -> [Obj] {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return try fetchHandler(type) as! [Obj]
        }
        return [Obj]()
    }

    public private(set) var updateSearchConfigurationCallCount = 0
    public var updateSearchConfigurationHandler: ((Any, Any) -> ())?
    public func updateSearchConfiguration<Value>(keypath: WritableKeyPath<SearchConfiguration, Value>, value: Value)  {
        updateSearchConfigurationCallCount += 1
        if let updateSearchConfigurationHandler = updateSearchConfigurationHandler {
            updateSearchConfigurationHandler(keypath, value)
        }
        
    }
}

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

