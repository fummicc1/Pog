//
//  RootView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import MapKit

struct RootView: View {

    @Environment(\.locationManager) var locationManager: LocationManager
    @Environment(\.store) var store: Store
    @Environment(\.placeManager) var placeManager: PlaceManager

    @AppStorage("shouldOnboarding") var shouldOnboarding: Bool = true

    var body: some View {
        if shouldOnboarding {
            WalkthroughPage(
                shouldOnboarding: _shouldOnboarding.projectedValue
            )
        } else {
            TabView {
                MapView(
                    model: MapModel(
                        locationManager: locationManager,
                        placeManager: placeManager,
                        store: store
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
                SettingsPage(
                    model: SettingsModel(
                        store: store,
                        locationManager: locationManager
                    )
                )
                .tabItem {
                    Image(systemSymbol: .gear)
                    Text("環境設定")
                }
            }
        }
    }
}
