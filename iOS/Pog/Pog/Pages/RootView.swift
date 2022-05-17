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

    var body: some View {
        TabView {
            MapView(
                model: MapModel(
                    locationManager: locationManager
                )
            )
            .tabItem {
                Image(systemSymbol: .map)
                Text("マップ")
            }
            PlaceLogPage(
                model: MapModel(
                    locationManager: locationManager
                )
            )
            .tabItem {
                Image(systemSymbol: .listBulletCircle)
                Text("ログ")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(locationManager: LocationManagerImpl.shared)
    }
}
