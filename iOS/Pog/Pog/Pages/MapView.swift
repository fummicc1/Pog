//
//  MapView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import CoreLocationUI
import SFSafeSymbols
import MapKit

struct MapView: View {

    @ObservedObject var model: MapModel
    @Binding var items: [Place]

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Map(
                coordinateRegion: $model.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: items,
                annotationContent: { item in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: item.lat,
                            longitude: item.long
                        )
                    ) {
                        Image(systemSymbol: .magnifyingglass)
                            .frame(width: 32, height: 32)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(Circle())
                            .onTapGesture {
                                model.selectedPlace = item
                            }
                    }
                }
            )
            .alert("Pogを快適に使用するために。",
                   isPresented: $model.needToAcceptAlwaysLocationAuthorization,
                   actions: {
                Button("設定へ") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }) {
                Text("Pogには位置情報のログを残す機能があります。\nこれらの機能を使用するために位置情報の許可をお願いします。")
            }
            LocationButton(.currentLocation) {
                model.onTapMyCurrentLocationButton()
            }
            .foregroundColor(Color(uiColor: .systemBackground))
            .background(Color(uiColor: .label))
            .cornerRadius(12)
            .labelStyle(.iconOnly)
            .alignmentGuide(.bottom) { _ in
                120
            }
            .alignmentGuide(.leading) { _ in
                -16
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            model: MapModel(locationManager: LocationManagerImpl.shared),
            items: .constant([])
        )
    }
}
