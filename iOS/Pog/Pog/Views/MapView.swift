//
//  MapView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import CoreLocationUI
import MapKit
import PartialSheet
import SFSafeSymbols
import SwiftUI

struct MapView: View {

    @StateObject var model: MapModel
    @State private var moveToHistoryPage: Bool = false

    @Environment(\.store) var store: Store
    @Environment(\.placeManager) var placeManager: PlaceManager
    @Environment(\.locationManager) var locationManager: LocationManager

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                if moveToHistoryPage {
                    NavigationLink(
                        destination:
                            InterestingPlaceVisitingListView(
                                model:
                                    InterestingPlaceVisitingListModel(
                                        store:
                                            store,
                                        placeManager:
                                            placeManager
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
                            coordinate:
                                CLLocationCoordinate2D(
                                    latitude:
                                        item
                                        .lat,
                                    longitude:
                                        item
                                        .lng
                                )
                        ) {
                            Image(
                                systemSymbol:
                                    model
                                    .checkPlaceIsInterseted(
                                        item
                                    )
                                    ? .checkmark
                                    : .mappin
                            )
                            .frame(width: 32, height: 32)
                            .background(
                                Color(
                                    uiColor:
                                        .systemBackground
                                )
                            )
                            .clipShape(Circle())
                            .onTapGesture {
                                let delay: Double
                                if model
                                    .selectedPlace
                                    != nil
                                {
                                    model
                                        .selectPlace(
                                            nil
                                        )
                                    delay =
                                        0.5
                                }
                                else {
                                    delay =
                                        0.1
                                }
                                DispatchQueue.main
                                    .asyncAfter(
                                        deadline:
                                            .now()
                                            + delay
                                    ) {
                                        model
                                            .selectPlace(
                                                item
                                            )
                                    }
                            }
                        }
                    }
                )
                .alert(
                    L10n.MapView.Location.toUseConfortably,
                    isPresented: $model
                        .needToAcceptAlwaysLocationAuthorization,
                    actions: {
                        Button(L10n.Common.openSettings) {
                            UIApplication.shared.open(
                                URL(
                                    string:
                                        UIApplication
                                        .openSettingsURLString
                                )!
                            )
                        }
                    }
                ) {
                    Text(
                        L10n.MapView.Location
                            .authorizeRecommendation
                    )
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
            .navigationTitle(L10n.MapView.Place.registerNotification)
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        moveToHistoryPage = true
                    } label: {
                        Label(
                            "History",
                            systemSymbol:
                                .listBulletRectanglePortrait
                        )
                        .labelStyle(.automatic)
                    }

                }
            })
        }
        .searchable(
            text: $model.searchText,
            prompt: Text(L10n.MapView.Place.searchPlacesToRegister),
            suggestions: {
                ForEach(0..<model.searchedWords.count, id: \.self) {
                    index in
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
                background: .solid(
                    Color(uiColor: .secondarySystemBackground)
                ),
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
                        place: place,
                        store: store,
                        locationManager: locationManager
                    )
                )
            }
        }
    }
}
