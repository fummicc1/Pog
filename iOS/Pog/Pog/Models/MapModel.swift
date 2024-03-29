//
//  MapModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Combine
import CoreLocation
import Foundation
import MapKit
import SwiftUI

class MapModel: ObservableObject {

    private let locationManager: LocationManager
    private let placeManager: PlaceManager
    private let store: Store
    private var cancellables: Set<AnyCancellable> = []

    @MainActor
    @Published
    var searchText: String = ""

    @MainActor
    @Published
    var showPartialSheet: Bool = false

    @MainActor
    @Published
    private(set) var selectedPlace: Place?

    @MainActor
    @Published
    private(set) var searchedWords: [String] = []

    @MainActor
    @Published
    var showPlaces: [Place] = []

    private var numberOfPlacesSearchRequestPerDay: CurrentValueSubject<Int, Never> = .init(0)
    private var lastSearchedDate: CurrentValueSubject<Date?, Never> = .init(nil)
    private var searchResults: CurrentValueSubject<[Place], Never> = .init([])
    private var interestingPlaces: CurrentValueSubject<[InterestingPlaceData], Never> = .init(
        [])

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
    init(locationManager: LocationManager, placeManager: PlaceManager, store: Store) {
        self.locationManager = locationManager
        self.placeManager = placeManager
        self.store = store

        locationManager.request()

        locationManager.authorizationStatus
            .map({
                $0 != CLAuthorizationStatus.authorizedAlways
                    && $0 != CLAuthorizationStatus.authorizedWhenInUse
            })
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
            .sink { places in
                self.searchResults.send(places)
            }
            .store(in: &cancellables)

        store.interestingPlaces
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { places in
                self.interestingPlaces.send(places)
            })
            .store(in: &cancellables)

        store.searchConfiguration
            .map(\.searchedWords)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchedWords)

        store.searchConfiguration
            .map(\.numberOfSearchPerDay)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { num in
                self.numberOfPlacesSearchRequestPerDay.send(num)
            })
            .store(in: &cancellables)

        store.searchConfiguration
            .map(\.lastSearchedDate)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { date in
                self.lastSearchedDate.send(date)
            })
            .store(in: &cancellables)

        searchResults
            .combineLatest(interestingPlaces)
            .map { searchPlaces, interestingPlaceDatas in
                interestingPlaceDatas.map {
                    Place(
                        lat: $0.lat,
                        lng: $0.lng,
                        icon: $0.icon,
                        name: $0.name
                            ?? L10n.MapView.Place
                            .failedToFetch
                    )
                } + searchPlaces
            }
            .assign(to: &$showPlaces)

    }

    @MainActor
    func onTapMyCurrentLocationButton() {
        guard let coordinate = locationManager.currentCoordinate else {
            return
        }
        region.center = coordinate
    }

    @MainActor
    func selectPlace(_ place: Place?) {
        selectedPlace = place
        showPartialSheet = place != nil
    }

    func onSubmitTextField() async {
        await placeManager.search(
            text: searchText,
            at: locationManager.currentCoordinate,
            useGooglePlaces: numberOfPlacesSearchRequestPerDay.value
                <= Const.numberOfPlacesApiCallPerDay
        )
        var new = await searchedWords
        let searchText = await self.searchText
        if !new.contains(searchText) {
            new.append(searchText)
        }
        let now = Date()
        let calendar: Calendar = .current
        if let last = lastSearchedDate.value, !calendar.isDate(last, inSameDayAs: now) {
            store.updateSearchConfiguration(
                keypath: \.lastSearchedDate,
                value: Date()
            )
            store.updateSearchConfiguration(
                keypath: \.numberOfSearchPerDay,
                value: 1
            )
        }
        else {
            if lastSearchedDate.value == nil {
                store.updateSearchConfiguration(
                    keypath: \.lastSearchedDate,
                    value: Date()
                )
            }
            store.updateSearchConfiguration(keypath: \.searchedWords, value: new)
            store.updateSearchConfiguration(
                keypath: \.numberOfSearchPerDay,
                value: numberOfPlacesSearchRequestPerDay.value + 1
            )
        }
    }

    func checkPlaceIsInterseted(_ place: Place) -> Bool {
        interestingPlaces.value.contains(where: { interestingPlaceData in
            let diffLat = abs(interestingPlaceData.lat - place.lat)
            let diffLng = abs(interestingPlaceData.lng - place.lng)
            return diffLat < 0.0001 && diffLng < 0.0001
        })
    }
}
