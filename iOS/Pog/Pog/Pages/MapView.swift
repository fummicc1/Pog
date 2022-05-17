//
//  MapView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import PartialSheet
import CoreLocationUI
import SFSafeSymbols
import MapKit

struct MapView: View {

    @ObservedObject var model: MapModel

    var body: some View {
        VStack {
            TextField("検索", text: $model.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit(of: .text) {
                    model.submit()
                }
            ZStack(alignment: .bottomLeading) {
                Map(
                    coordinateRegion: $model.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.none),
                    annotationItems: model.searchResults,
                    annotationContent: { item in
                        MapAnnotation(
                            coordinate: CLLocationCoordinate2D(
                                latitude: item.lat,
                                longitude: item.lng
                            )
                        ) {
                            Image(systemSymbol: .mappin)
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
                    80
                }
                .alignmentGuide(.leading) { _ in
                    -16
                }
            }
        }
        .background(Color.clear)
        .partialSheet(isPresented: Binding(get: {
            model.selectedPlace != nil
        }, set: { value, _ in
            if !value {
                model.selectedPlace = nil
            }
        })) {
            if let place = model.selectedPlace {
                SearchPlacePage(model: SearchPlaceModel(), place: place)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            model: MapModel(locationManager: LocationManagerImpl.shared)
        )
    }
}
