import SwiftUI
import Combine
import MapKit
import CoreLocation


class PlaceLogModel: ObservableObject {

    private let locationManager: LocationManager
    private let store: Store
    private var cancellables: Set<AnyCancellable> = []

    @Published var selectedPlace: Place?
    @Published var searchResults: [Place] = []
    @Published var searchText: String = ""


    @Published var region: MKCoordinateRegion = .init(
        // Default: Tokyo Region
        center: CLLocationCoordinate2D(
            latitude: 35.652832,
            longitude: 139.839478
        ),
        span: .init(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    )
    @Published var needToAcceptAlwaysLocationAuthorization: Bool = false

    @Published var logs: [PlaceLog] = []
    @Published var dates: [Date] = []
    @Published var polylines: [MKPolyline] = []
    @Published var selectedDate: Date?
    @Published var selectedPolyline: MKPolyline?

    init(
        locationManager: LocationManager,
        store: Store
    ) {
        self.locationManager = locationManager
        self.store = store

        locationManager.request()

        locationManager.authorizationStatus
            .map({ $0 != CLAuthorizationStatus.authorizedAlways && $0 != CLAuthorizationStatus.authorizedWhenInUse })
            .assign(to: &$needToAcceptAlwaysLocationAuthorization)

        locationManager
            .coordinate
            .first()
            .sink { coordinate in
                self.region.center = coordinate
            }
            .store(in: &cancellables)
    }

    func onTapMyCurrentLocationButton() {
        guard let coordinate = locationManager.currentCoordinate else {
            return
        }
        region.center = coordinate
    }

    func onApepar() {
        let calendar = Calendar.current
        store.logs
            .assign(to: &$logs)
        store.logs
            .map({ logs -> [[CLLocationCoordinate2D]] in
                var ret: [Date: [CLLocationCoordinate2D]] = [:]
                for log in logs {
                    let coordinate = CLLocationCoordinate2D(
                        latitude: log.lat,
                        longitude: log.lng
                    )
                    guard let date = log.date else {
                        continue
                    }
                    if let key = ret.keys.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
                        ret[key]?.append(coordinate)
                    } else {
                        ret[date] = [coordinate]
                    }
                }
                self.dates = ret.keys.map({ $0 })
                return ret.values.map({ $0 })
            })
            .map({ values in
                values.map { coordinates in
                    MKPolyline(coordinates: coordinates, count: coordinates.count)
                }
            })
            .assign(to: &$polylines)
    }

    func onSelect(date: Date) {
        if let index = dates.firstIndex(where: { $0 == date }) {
            if polylines.count <= index {
                return
            }
            selectedDate = dates[index]
            selectedPolyline = polylines[index]
        }
    }
}
