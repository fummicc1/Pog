//
//  RootView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import MapKit

struct RootView: View {

    let locationManager: LocationManager
    let store: Store

    @AppStorage("shouldOnboarding") var shouldOnboarding: Bool = true

    var body: some View {
        if shouldOnboarding {
            WalkthroughPage(shouldOnboarding: _shouldOnboarding.projectedValue)
        } else {
            TabView {
                MapView(
                    model: MapModel(
                        locationManager: locationManager,
                        placeManager: PlaceManagerImpl()
                    )
                )
                .tabItem {
                    Image(systemSymbol: .map)
                    Text("マップ")
                }
                PlaceLogPage(
                    model: PlaceLogModel(
                        locationManager: locationManager,
                        store: store
                    )
                )
                .tabItem {
                    Image(systemSymbol: .listBulletCircle)
                    Text("ログ")
                }
                SettingsPage()
                    .tabItem {
                        Image(systemSymbol: .gear)
                        Text("設定")
                    }
            }
        }
    }
}
