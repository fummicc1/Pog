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
    @State private var moveToHistoryPage: Bool = false
    
    @Environment(\.store) var store: Store
    @Environment(\.placeManager) var placeManager: PlaceManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                if moveToHistoryPage {
                    NavigationLink(
                        destination: InterestingPlaceVisitingListView(
                            model: InterestingPlaceVisitingListModel(
                                store: store,
                                placeManager: placeManager
                            )
                        ),
                        isActive: $moveToHistoryPage
                    ) {
                        EmptyView()
                    }
                }
                Map(
                    coordinateRegion: $model.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.none),
                    annotationItems: model.showPlaces,
                    annotationContent: { item in
                        MapAnnotation(
                            coordinate: CLLocationCoordinate2D(
                                latitude: item.lat,
                                longitude: item.lng
                            )
                        ) {
                            Image(systemSymbol: model.checkPlaceIsInterseted(item) ? .checkmark : .mappin)
                                .frame(width: 32, height: 32)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(Circle())
                                .onTapGesture {
                                    let delay: Double
                                    if model.selectedPlace != nil {
                                        model.selectPlace(nil)
                                        delay = 0.5
                                    } else {
                                        delay = 0.1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                        model.selectPlace(item)
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
                LocationButton(.currentLocation) {
                    model.onTapMyCurrentLocationButton()
                }
                .foregroundColor(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .labelStyle(.iconOnly)
                .padding(.vertical, 32)
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("通知を登録")
        }
        .toolbar(content: {
            ToolbarItem {
                Button {

                } label: {
                    Label("History", systemSymbol: .listBulletRectanglePortrait)
                        .labelStyle(.automatic)
                }

            }
        })
        .searchable(
            text: $model.searchText,
            prompt: Text("通知をする場所を検索"),
            suggestions: {
                ForEach(0..<model.searchedWords.count, id: \.self) { index in
                    let searchedWord = model.searchedWords[index]
                    Text(searchedWord)
                        .searchCompletion(searchedWord)
                }
            }
        )
        .onSubmit(of: .search) {
            Task {
                await model.onSubmitTextField()
            }
        }
        .partialSheet(
            isPresented: $model.showPartialSheet,
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
                SearchPlacePage(
                    model: SearchPlaceModel(
                        store: store
                    ),
                    place: place
                )
            }
        }
    }
}
