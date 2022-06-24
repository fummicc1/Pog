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

    @Published var featuredLogs: [PlaceLog] = []
    @Published var logs: [PlaceLog] = []
    @Published var dates: [Date] = []
    private var polylines: [Date: MKPolyline] = [:]
    @Published var selectedDate: Date?
    @Published var selectedPolyline: MKPolyline?

    private let que = DispatchQueue(label: "dev.fummicc1.Pog.PlacelogModel.Que")

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
        // TODO: diffable update
        store.logs.combineLatest($selectedDate)
            .receive(on: que)
            .map({ (places, selectedDate) -> [PlaceLog] in
                guard let selectedDate = selectedDate else {
                    return []
                }
                return places.filter({ place in
                    guard let date = place.date else {
                        return false
                    }
                    return calendar.isDate(selectedDate, inSameDayAs: date)
                })
            })
            .map { l in
                // sort by `Date`
                let logs = l.sorted { head, tail in
                    guard let h = head.date, let t = tail.date else {
                        return false
                    }
                    return h.timeIntervalSince1970 < t.timeIntervalSince1970
                }
                var fars: [PlaceLog] = []
                // find log which is a large distance from previous log.
                var k = 0
                for (i, log) in logs.enumerated() {
                    if i == 0 {
                        continue
                    }
                    let location = CLLocation(
                        latitude: log.lat,
                        longitude: log.lng
                    )
                    let beforeLocation = CLLocation(
                        latitude: logs[k].lat,
                        longitude: logs[k].lng
                    )
                    let distance = location.distance(from: beforeLocation)
                    let thresholdDistance: Double = 500
                    if distance < thresholdDistance {
                        print(distance)
                        continue
                    }
                    guard let now = log.date?.timeIntervalSince1970, let before = logs[k].date?.timeIntervalSince1970 else {
                        continue
                    }
                    let thresholdTime: Double = 60 * 5
                    if now - before >= thresholdTime {
                        fars.append(log)
                        k = i
                    }
                }
                return fars
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$featuredLogs)

        store.logs
            .receive(on: que)
            .map({ logs -> [Date: MKPolyline] in
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
                DispatchQueue.main.async {
                    self.dates = ret.keys.sorted().reversed()
                }
                return ret
                    .mapValues { coordinates in
                        MKPolyline(coordinates: coordinates, count: coordinates.count)
                    }
            })
            .receive(on: DispatchQueue.main)
            .sink { values in
                self.polylines = values
            }
            .store(in: &cancellables)

        $featuredLogs.sink { logs in
            print(logs)
        }.store(in: &cancellables)
    }

    func onSelect(date: Date) {
        selectedDate = date
        selectedPolyline = polylines[date]
    }
}
