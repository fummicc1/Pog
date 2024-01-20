//
//  RootView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import MapKit
import SwiftUI

struct RootView: View {

    @Environment(\.locationManager) var locationManager: LocationManager
    @Environment(\.store) var store: LocalDataStore
    @Environment(\.placeManager) var placeManager: PlaceManager

    @AppStorage("shouldOnboarding") var shouldOnboarding: Bool = true

    var body: some View {
        if shouldOnboarding {
            WalkthroughPage(
                shouldOnboarding: _shouldOnboarding.projectedValue
            )
        }
        else {
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
                    Text(L10n.Common.map)
                }
                PlaceLogPage(
                    model: PlaceLogModel(
                        locationManager: locationManager,
                        store: store
                    )
                )
                .tabItem {
                    Image(systemSymbol: .listBulletCircle)
                    Text(L10n.Common.log)
                }
                SettingsPage(
                    model: SettingsModel(
                        store: store,
                        locationManager: locationManager
                    )
                )
                .tabItem {
                    Image(systemSymbol: .gear)
                    Text(L10n.Common.environment)
                }
            }
        }
    }
}
