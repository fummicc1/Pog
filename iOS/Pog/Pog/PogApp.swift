//
//  PogApp.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import Combine
import FirebaseCore

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
    var store: Store = StoreImpl.shared
    var cancellable: AnyCancellable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        cancellable = locationManager.coordinate
            .sink { coordinate in
                let log = PlaceLog(context: self.store.context)
                log.lat = coordinate.latitude
                log.lng = coordinate.longitude
                log.date = Date()
                log.color = "0x007AFF"
                try? self.store.context.save()
            }
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner]
    }
}
