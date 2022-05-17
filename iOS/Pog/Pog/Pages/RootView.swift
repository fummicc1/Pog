//
//  RootView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import MapKit

struct RootView: View {

    @State private var searchText: String = ""
    @State private var searchResults: [Place] = []

    let locationManager: LocationManager

    var body: some View {
        NavigationView {
            MapView(
                model: MapModel(
                    locationManager: locationManager
                ),
                items: $searchResults
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("マップ")
        }.searchable(text: $searchText)
            .onSubmit(of: .search) {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = searchText
                let search = MKLocalSearch(request: request)
                Task {
                    do {
                        let response = try await search.start()
                        await MainActor.run(body: {
                            self.searchResults = response.mapItems
                                .map(\.placemark)
                                .compactMap({ placemark in
                                    guard let coordinate = placemark.location?.coordinate else {
                                        return nil
                                    }
                                    return Place(
                                        lat: coordinate.latitude,
                                        long: coordinate.longitude,
                                        name: placemark.title ?? ""
                                    )
                                })
                        })
                    } catch {
                        print(error)
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(locationManager: LocationManagerImpl.shared)
    }
}
