//
//  PogApp.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import Combine
import FirebaseCore
import FirebaseAnalytics

@main
struct PogApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
            .attachPartialSheetToRoot()
            .environment(\.placeManager, PlaceManagerImpl())
            .environment(\.locationManager, appDelegate.locationManager)
            .environment(\.managedObjectContext, appDelegate.store.context)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var locationManager: LocationManager = LocationManagerImpl.shared
    var store: Store = StoreEnvironemtnKey.defaultValue
    var cancellables: Set<AnyCancellable> = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        // MARK: Observe location updates
        locationManager.coordinate
            .sink { coordinate in
                let log = PlaceLog(context: self.store.context)
                log.lat = coordinate.latitude
                log.lng = coordinate.longitude
                log.date = Date()
                log.color = "0x007AFF"
                do {
                    try self.store.context.save()
                } catch {
                    assertionFailure("\(error)")
                }
            }
            .store(in: &cancellables)
        locationManager.onEnterRegion
            .sink { region in
                do {
                    let places = try self.store.fetch(type: InterestingPlace.self)
                    let visitingLog = InterestingPlaceVisitingLog(
                        context: self.store.context
                    )
                    visitingLog.visitedAt = Date()
                    guard let place = places.first(
                        where: { $0.lat == region.center.latitude && $0.lng == region.center.longitude }) else {
                        assertionFailure()
                        return
                    }
                    visitingLog.place = place
                    try self.store.context.save()
                } catch {
                    assertionFailure("\(error)")
                }
            }
            .store(in: &cancellables)
        locationManager.onExitRegion
            .sink { region in
                do {
                    let logs = try self.store.fetch(type: InterestingPlaceVisitingLog.self)
                    guard let log = logs.first(where: {
                        $0.place?.lat == region.center.latitude && $0.place?.lng == region.center.longitude
                    }) else {
                        assertionFailure()
                        return
                    }
                    log.exitedAt = Date()
                    try self.store.context.save()
                } catch {
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
                    value: locationSettings.allowsBackgroundLocationUpdates
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner]
    }
}
