//
//  PogApp.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import Combine

@main
struct PogApp: App {

    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView(locationManager: appDelegate.locationManager)
                .environment(\.managedObjectContext, appDelegate.store.context)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {

    var locationManager: LocationManager = LocationManagerImpl.shared
    var store: Store = StoreImpl()
    var cancellable: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        cancellable = locationManager.coordinate
            .sink { coordinate in
                let log = PlaceLog(context: self.store.context)
                log.lat = coordinate.latitude
                log.lng = coordinate.longitude
                log.date = Date()
                log.color = "0x007AFF"
                try? self.store.save()
            }
        return true
    }
}
