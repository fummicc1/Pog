//
//  SearchPlaceModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Foundation
import CoreLocation
import SwiftUI
import UserNotifications

class SearchPlaceModel: ObservableObject {

    @Published var alreadyInteresting: Bool = false
    @Published var storedInterestingPlace: InterestingPlace?
    @Published var error: String? = nil

    func willDeleteInterestingPlace() {
        guard let storedInterestingPlace = storedInterestingPlace else {
            return
        }
        let id = "\(storedInterestingPlace.lng)/\(storedInterestingPlace.lng)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    func didAddInterestingPlace() async {
        guard let storedInterestingPlace = storedInterestingPlace else {
            return
        }
        let id = "\(storedInterestingPlace.lng)/\(storedInterestingPlace.lng)"
        let content = UNMutableNotificationContent()
        content.title = "気になる場所が近くにあります"
        content.body = "アプリを開いて確認しましょう"
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
        } catch {
            self.error = error.localizedDescription
        }
    }
}
