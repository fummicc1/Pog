//
//  SettingsModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/01.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import CoreLocation
import UserNotifications

class SettingsModel: ObservableObject {
    @MainActor @Published private(set) var desiredAccuracy: Double?
    @MainActor @Published private(set) var allowsBackgroundLocationUpdates: Bool = true
    @MainActor @Published private(set) var isAquiringAccuracyLocation: String = L10n.SettingsModel.Location.fuzzyLocation
    @MainActor @Published private(set) var locationAuthorizationStatus: String = L10n.SettingsModel.Authorization.confirmNextTime

    private let store: Store
    private let locationManager: LocationManager
    private var cancellables: Set<AnyCancellable> = []

    private var latestLocationSettingsData: LocationSettingsData? {
        @MainActor didSet {
            guard let settings = latestLocationSettingsData else {
                return
            }
            self.desiredAccuracy = settings.desiredAccuracy
            self.allowsBackgroundLocationUpdates = settings.allowsBackgroundLocationUpdates
        }
    }

    init(store: Store, locationManager: LocationManager) {
        self.store = store
        self.locationManager = locationManager
        store.locationSettings
            .receive(on: DispatchQueue.main)
            .sink { locationSettingsData in
                DispatchQueue.main.async {
                    self.latestLocationSettingsData = locationSettingsData
                }
            }
            .store(in: &cancellables)

        locationManager.authorizationStatus
            .map { status in
                switch status {
                case .notDetermined:
                    return L10n.SettingsModel.Authorization.confirmNextTime
                case .authorizedAlways:
                    return L10n.SettingsModel.Authorization.always
                case .authorizedWhenInUse:
                    return L10n.SettingsModel.Authorization.whileInUse
                case .denied:
                    return L10n.SettingsModel.Authorization.notAuthorized
                default:
                    return L10n.Common.unknown
                }
            }
            .assign(to: &$locationAuthorizationStatus)

        locationManager.isAuthorizedForPreciseLocation
            .map { isAccurate in
                if isAccurate {
                    return L10n.SettingsModel.Location.preciseLocation
                } else {
                    return L10n.SettingsModel.Location.fuzzyLocation
                }
            }
            .assign(to: &$isAquiringAccuracyLocation)
    }

    @MainActor
    func onAppear() {
        if let settings = try? store.fetch(type: LocationSettingsData.self).first {
            self.latestLocationSettingsData = settings
        }
    }

    @MainActor
    func updateDesiredAccuracy(_ desiredAccuracy: Double?) {
        self.desiredAccuracy = desiredAccuracy
    }

    @MainActor
    func commitDesiredAccuracyChange() {
        let desiredAccuracy = self.desiredAccuracy ?? Const.defaultDesiredAccuracy
        updateSettings(keypath: \.desiredAccuracy, value: desiredAccuracy)
    }

    @MainActor
    func updateBackgroundLocationUpdates(isAccepted: Bool) {
        self.allowsBackgroundLocationUpdates = isAccepted
        updateSettings(keypath: \.allowsBackgroundLocationUpdates, value: isAccepted)
    }

    func totallyDeleteLogs() {
        let log = PlaceLogData.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let batchRequest = NSBatchDeleteRequest(fetchRequest: log)
        do {
            try store.deleteWithBatch(batchRequest)
        } catch {
            print(error)
        }
    }

    func totallyDeleteInterestingPlaces() {
        let interests = InterestingPlaceData.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let batch = NSBatchDeleteRequest(fetchRequest: interests)
        do {
            try store.deleteWithBatch(batch)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } catch {
            print(error)
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func updateSettings<V>(keypath: ReferenceWritableKeyPath<LocationSettingsData, V>, value: V) {
        let request = LocationSettingsData.fetchRequest()
        if let latestLocationSettingsData = try? store.context.fetch(request), !latestLocationSettingsData.isEmpty {
            latestLocationSettingsData.last?[keyPath: keypath] = value
        } else {
            let latestLocationSettingsData = LocationSettingsData(context: store.context)
            latestLocationSettingsData[keyPath: keypath] = value
        }
        do {
            try store.context.save()
        } catch {
            print(error)
        }
    }
}
