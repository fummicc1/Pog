//
//  RootView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        MapView(
            model: MapModel(locationManager: LocationManagerImpl.shared)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
