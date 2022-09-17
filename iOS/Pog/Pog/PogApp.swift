//
//  PogApp.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Combine
import FirebaseAnalytics
import FirebaseCore
import SwiftUI

@main
struct PogApp: App {

    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .attachPartialSheetToRoot()
                .environment(
                    \.managedObjectContext,
                    appDelegate.store.context
                )
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var locationManager: LocationManager = LocationManagerImpl.shared
    var store: Store = StoreEnvironemtnKey.defaultValue
    var cancellables: Set<AnyCancellable> = []

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey:
            Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        #if DEBUG
            Analytics.setAnalyticsCollectionEnabled(false)
        #else
            Analytics.setAnalyticsCollectionEnabled(true)
        #endif
        // MARK: Observe location updates
        locationManager.coordinate.combineLatest(store.locationSettings)
            .filter({ $0.1?.allowsBackgroundLocationUpdates == true })
            .map(\.0)
            .sink { coordinate in
                let log = PlaceLogData(context: self.store.context)
                log.lat = coordinate.latitude
                log.lng = coordinate.longitude
                log.date = Date()
                log.color = "0x007AFF"
                do {
                    try self.store.context.save()
                }
                catch {
                    assertionFailure("\(error)")
                }
            }
            .store(in: &cancellables)
        locationManager.onEnterRegion
            .sink { region in
                do {
                    let places = try self.store.fetch(
                        type: InterestingPlaceData.self
                    )
                    let visitingLog = InterestingPlaceVisitingLogData(
                        context: self.store.context
                    )
                    visitingLog.visitedAt = Date()
                    guard
                        let place = places.first(
                            where: {
                                $0.lat
                                    == region
                                    .center
                                    .latitude
                                    && $0.lng
                                        == region
                                        .center
                                        .longitude
                            })
                    else {
                        assertionFailure()
                        return
                    }
                    visitingLog.place = place
                    try self.store.context.save()
                }
                catch {
                    assertionFailure("\(error)")
                }
            }
            .store(in: &cancellables)
        locationManager.onExitRegion
            .sink { region in
                do {
                    let logs = try self.store.fetch(
                        type: InterestingPlaceVisitingLogData
                            .self
                    )
                    guard
                        let log = logs.first(where: {
                            $0.place?.lat
                                == region.center
                                .latitude
                                && $0.place?.lng
                                    == region
                                    .center
                                    .longitude
                                && $0.exitedAt
                                    == nil
                        })
                    else {
                        assertionFailure()
                        return
                    }
                    log.exitedAt = Date()
                    try self.store.context.save()
                }
                catch {
                    assertionFailure("\(error)")
                }
            }
            .store(in: &cancellables)

        UNUserNotificationCenter.current().delegate = self

        store.locationSettings
            .sink { locationSettings in
                guard let locationSettings = locationSettings else {
                    return
                }
                self.locationManager.updateLocationManager(
                    keypath: \.allowsBackgroundLocationUpdates,
                    value: locationSettings
                        .allowsBackgroundLocationUpdates
                )
                self.locationManager.updateLocationManager(
                    keypath: \.distanceFilter,
                    value: locationSettings.distanceFilter
                )
                self.locationManager.updateLocationManager(
                    keypath: \.desiredAccuracy,
                    value: locationSettings.desiredAccuracy
                )
            }
            .store(in: &cancellables)
        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner]
    }
}
