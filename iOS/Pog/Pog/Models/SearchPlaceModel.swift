//
//  SearchPlaceModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import CoreLocation
import Foundation
import SwiftUI
import UserNotifications

class SearchPlaceModel: ObservableObject {

    @Published var alreadyInteresting: Bool = false
    @Published var storedInterestingPlace: InterestingPlaceData?
    @Published var error: String? = nil
    @Published var interestingPlaces: [InterestingPlaceData] = []

    let store: LocalDataStore
    let locationManager: LocationManager

    let place: Place

    init(place: Place, store: LocalDataStore, locationManager: LocationManager) {
        self.place = place
        self.store = store
        self.locationManager = locationManager

        store.interestingPlaces
            .assign(to: &$interestingPlaces)

        locationManager.monitoringRegions
            .compactMap({ $0 as? [CLCircularRegion] })
            .map({ regions in
                regions.map(\.center).contains(
                    CLLocationCoordinate2D(
                        latitude: place.lat,
                        longitude: place.lng
                    )
                )
            })
            .receive(on: DispatchQueue.main)
            .assign(to: &$alreadyInteresting)
    }

    func willDeleteInterestingPlace() {
        guard let storedInterestingPlace = storedInterestingPlace else {
            return
        }
        let id = "\(storedInterestingPlace.lng)/\(storedInterestingPlace.lng)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [id])
        locationManager.resignMonitoringRegion(
            at: CLLocationCoordinate2D(
                latitude: storedInterestingPlace.lat,
                longitude: storedInterestingPlace.lng
            )
        )
        alreadyInteresting = false
    }

    func didAddInterestingPlace() async {
        guard
            let isAuthorized = try? await UNUserNotificationCenter.current()
                .requestAuthorization(
                    options: [.alert, .badge, .sound]
                ), isAuthorized
        else {
            return
        }

        guard let storedInterestingPlace = storedInterestingPlace else {
            return
        }
        let id = "\(storedInterestingPlace.lng)/\(storedInterestingPlace.lng)"
        let content = UNMutableNotificationContent()
        content.title =
            "\(storedInterestingPlace.name ?? L10n.SearchPlaceModel.Notification.InterestingPlace.defaultName)"
            + L10n.SearchPlaceModel.Notification.InterestingPlace.existNearBy
        content.body = L10n.SearchPlaceModel.Notification.confirmWithApp
        let trigger = UNLocationNotificationTrigger(
            region: CLCircularRegion(
                center: CLLocationCoordinate2D(
                    latitude: storedInterestingPlace.lat,
                    longitude: storedInterestingPlace.lng
                ),
                radius: storedInterestingPlace.distanceMeter,
                identifier: id
            ),
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        do {
            try await UNUserNotificationCenter.current().add(request)
            locationManager.startMonitoringRegion(
                id: id,
                at: CLLocationCoordinate2D(
                    latitude: storedInterestingPlace.lat,
                    longitude: storedInterestingPlace.lng
                ),
                distance: storedInterestingPlace.distanceMeter
            )
        }
        catch {
            self.error = error.localizedDescription
        }
    }
}
