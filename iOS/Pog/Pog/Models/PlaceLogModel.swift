import Combine
import CoreLocation
import MapKit
import SwiftUI

class PlaceLogModel: ObservableObject {

    private let locationManager: LocationManager
    private let store: Store
    private var cancellables: Set<AnyCancellable> = []

    @MainActor
    @Published var selectedPlace: Place?

    @MainActor
    @Published var searchResults: [Place] = []

    @MainActor
    @Published var searchText: String = ""

    @MainActor
    @Published
    var region: MKCoordinateRegion = .init(
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
    @MainActor
    @Published
    var needToAcceptAlwaysLocationAuthorization: Bool = false

    @MainActor
    @Published
    var featuredLogs: [PlaceLogData] = []

    @MainActor
    @Published
    var dates: [Date] = []

    @MainActor
    @Published
    var selectedDate: Date = Date()

    @MainActor
    @Published
    var selectedPolyline: MKPolyline?

    private let que = DispatchQueue(label: "dev.fummicc1.Pog.PlacelogDataModel.Que")

    init(
        locationManager: LocationManager,
        store: Store
    ) {
        self.locationManager = locationManager
        self.store = store

        locationManager.request()

        locationManager.authorizationStatus
            .map({
                $0 != CLAuthorizationStatus.authorizedAlways
                    && $0 != CLAuthorizationStatus.authorizedWhenInUse
            })
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
        // TODO: diffable update
        let logData = store.logs.combineLatest($selectedDate)
            .receive(on: que)
            .map({ (places, selectedDate) -> ([Date], [PlaceLogData]) in
                var dates: Set<Date> = []
                var logs: [PlaceLogData] = []
                for place in places {
                    guard let date = place.date else {
                        continue
                    }
                    dates.insert(date.dropTime())
                    if calendar.isDate(
                        selectedDate,
                        inSameDayAs: date
                    ) {
                        logs.append(place)
                    }
                }
                let sortedDates = Array(dates)
                    .sorted(
                        using: KeyPathComparator(
                            \.self,
                            order: .reverse
                        )
                    )
                return (sortedDates, logs)
            })
            .handleEvents(receiveOutput: { (dates, _) in
                DispatchQueue.main.async {
                    self.dates = dates
                }
            })
            .map(\.1)
            .map { l in
                // sort by `Date`
                let logs = l.sorted { head, tail in
                    guard let h = head.date, let t = tail.date else {
                        return false
                    }
                    return h.timeIntervalSince1970
                        < t.timeIntervalSince1970
                }
                var fars: [PlaceLogData] = []
                let coordinates: [CLLocationCoordinate2D] = l.map { log in
                    CLLocationCoordinate2D(
                        latitude: log.lat,
                        longitude: log.lng
                    )
                }
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
                    let distance = location.distance(
                        from: beforeLocation
                    )
                    let thresholdDistance: Double = 500
                    if distance < thresholdDistance {
                        print(distance)
                        continue
                    }
                    guard let now = log.date?.timeIntervalSince1970,
                        let before = logs[k].date?
                            .timeIntervalSince1970
                    else {
                        continue
                    }
                    let thresholdTime: Double = 60 * 5
                    if now - before >= thresholdTime {
                        fars.append(log)
                        k = i
                    }
                }
                let polyline = MKPolyline(
                    coordinates: coordinates,
                    count: coordinates.count
                )
                return (fars, polyline)
            }
            .share()
            .receive(on: DispatchQueue.main)

        logData.map(\.0)
            .assign(to: &$featuredLogs)

        logData.map(\.1)
            .map { $0 as MKPolyline? }
            .assign(to: &$selectedPolyline)
    }

    func onSelect(date: Date) {
        selectedDate = date
    }
}
