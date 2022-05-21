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
import SwiftUI

class MapModel: ObservableObject {

    private let locationManager: LocationManager
    private let placeManager: PlaceManager
    private var cancellables: Set<AnyCancellable> = []

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "date", ascending: true)
    ]) var logs: FetchedResults<PlaceLog>
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

    init(locationManager: LocationManager, placeManager: PlaceManager) {
        self.locationManager = locationManager
        self.placeManager = placeManager

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

        locationManager.coordinate
            .sink { coordinate in
                placeManager.searchNearby(at: coordinate)
            }
            .store(in: &cancellables)

        placeManager.placesPublisher
            .assign(to: &$searchResults)

        placeManager.search(text: searchText)
    }

    func onTapMyCurrentLocationButton() {
        guard let coordinate = locationManager.currentCoordinate else {
            return
        }
        region.center = coordinate
    }

    func onSubmitTextField() {
        placeManager.search(text: searchText)
    }
}
