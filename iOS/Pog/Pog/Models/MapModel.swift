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
    private let store: Store
    private var cancellables: Set<AnyCancellable> = []

    @Published private var numberOfPlacesSearchRequestPerDay: Int = 0
    @Published private var lastSearchedDate: Date?
    @MainActor @Published var logs: [PlaceLog] = []
    @MainActor @Published private(set) var selectedPlace: Place?
    @MainActor @Published var searchResults: [Place] = []
    @MainActor @Published var searchText: String = ""
    @MainActor @Published var showPartialSheet: Bool = false
    @MainActor @Published private(set) var searchedWords: [String] = []

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

    @MainActor
    init(locationManager: LocationManager, placeManager: PlaceManager, store: Store) {
        self.locationManager = locationManager
        self.placeManager = placeManager
        self.store = store

        locationManager.request()

        locationManager.authorizationStatus
            .map({ $0 != CLAuthorizationStatus.authorizedAlways && $0 != CLAuthorizationStatus.authorizedWhenInUse })
            .receive(on: DispatchQueue.main)
            .assign(to: &$needToAcceptAlwaysLocationAuthorization)

        locationManager
            .coordinate
            .first()
            .receive(on: DispatchQueue.main)
            .sink { coordinate in
                self.region.center = coordinate
            }
            .store(in: &cancellables)

        locationManager.coordinate
            .sink { coordinate in
                placeManager.searchNearby(at: coordinate)
            }
            .store(in: &cancellables)

        placeManager
            .placesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)

        store.logs
            .map { logs in
                return logs.sorted { head, tail in
                    (head.date?.timeIntervalSince1970 ?? 0) > (tail.date?.timeIntervalSince1970 ?? 0)
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$logs)

        store.searchConfiguration
            .map(\.searchedWords)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchedWords)

        store.searchConfiguration
            .map(\.numberOfSearchPerDay)
            .receive(on: DispatchQueue.main)
            .assign(to: &$numberOfPlacesSearchRequestPerDay)

        store.searchConfiguration
            .map(\.lastSearchedDate)
            .receive(on: DispatchQueue.main)
            .assign(to: &$lastSearchedDate)
    }

    func onTapMyCurrentLocationButton() {
        guard let coordinate = locationManager.currentCoordinate else {
            return
        }
        region.center = coordinate
    }

    func selectPlace(_ place: Place?) {
        Task { @MainActor in
            selectedPlace = place
            showPartialSheet = place != nil
        }
    }

    func onSubmitTextField() async {
        placeManager.search(
            text: await searchText,
            useGooglePlaces: numberOfPlacesSearchRequestPerDay <= 30
        )
        var new = await searchedWords
        if !new.contains(await searchText) {
            new.append(await searchText)
        }
        let now = Date()
        let calendar: Calendar = .current
        if let last = lastSearchedDate, !calendar.isDate(last, inSameDayAs: now) {
            store.updateSearchConfiguration(keypath: \.lastSearchedDate, value: Date())
            store.updateSearchConfiguration(keypath: \.numberOfSearchPerDay, value: 1)
        } else {
            if lastSearchedDate == nil {
                store.updateSearchConfiguration(keypath: \.lastSearchedDate, value: Date())
            }
            store.updateSearchConfiguration(keypath: \.searchedWords, value: new)
            store.updateSearchConfiguration(keypath: \.numberOfSearchPerDay, value: numberOfPlacesSearchRequestPerDay + 1)
        }
    }

    func checkPlaceIsInterseted(_ place: Place) -> Bool {
        placeManager.places.contains(place)
    }
}
