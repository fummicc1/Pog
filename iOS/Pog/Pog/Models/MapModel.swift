//
//  MapModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import MapKit
import Combine
import Foundation
import CoreLocation

class MapModel: ObservableObject {

    private let locationManager: LocationManager
    private var cancellables: Set<AnyCancellable> = []

    @Published var selectedPlace: Place?

    @Published var region: MKCoordinateRegion = .init(
        // Default: Tokyo Region
        center: CLLocationCoordinate2D(
            latitude: 35.652832,
            longitude: 139.839478
        ),
        span: .init(
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
    )
    @Published var needToAcceptAlwaysLocationAuthorization: Bool = false

    init(locationManager: LocationManager) {
        self.locationManager = locationManager

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
}
