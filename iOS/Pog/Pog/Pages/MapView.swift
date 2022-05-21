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

    @StateObject var model: MapModel

    var body: some View {
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
                                    let delay: Double
                                    if model.selectedPlace != nil {
                                        model.selectedPlace = nil
                                        delay = 0.5
                                    } else {
                                        delay = 0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                        model.selectedPlace = item
                                    }
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
                HStack {
                    LocationButton(.currentLocation) {
                        model.onTapMyCurrentLocationButton()
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .labelStyle(.iconOnly)
                    TextField("ここで検索", text: $model.searchText)
                        .keyboardType(.webSearch)
                        .onSubmit(of: .text) {
                            model.onSubmitTextField()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(24)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea(.container, edges: .top)
        .partialSheet(
            isPresented: Binding(get: {
                $model.selectedPlace.wrappedValue != nil
            }, set: { isPresented in
                if !isPresented {
                    $model.selectedPlace.wrappedValue = nil
                }
            }),
            iPhoneStyle: PSIphoneStyle(
                background: .solid(Color(uiColor: .secondarySystemBackground)),
                handleBarStyle: .solid(.secondary),
                cover: .disabled,
                cornerRadius: 10
            ),
            iPadMacStyle: .init(
                backgroundColor: Color(UIColor.secondarySystemBackground),
                closeButtonStyle: .icon(
                    image: Image(systemName: "xmark"),
                    color: Color.secondary
                )
            )
        ) {
            if let place = model.selectedPlace {
                SearchPlacePage(model: SearchPlaceModel(), place: place)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            model: MapModel(
                locationManager: LocationManagerImpl.shared,
                placeManager: PlaceManagerImpl()
            )
        )
    }
}
