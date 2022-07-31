//
//  InterestingPlaceVisitingListView.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/08.
//

import SwiftUI
import MapKit

struct InterestingPlaceVisitingListView: View {

    @ObservedObject var model: InterestingPlaceVisitingListModel
    @Environment(\.store) var store: Store
    @State private var moveToEditLogPage: InterestingPlaceVisitingLog?

    var body: some View {
        if model.places.isEmpty {
            Text("FailedToFetchRegisteredPlaceName")
        }
        ScrollView {
            LazyVStack {
                ForEach(model.places) { place in
                    let region: MKCoordinateRegion = .init(
                        center: CLLocationCoordinate2D(
                            latitude: place.lat,
                            longitude: place.lng
                        ),
                        span: .init(
                            latitudeDelta: 0.001,
                            longitudeDelta: 0.001
                        )
                    )
                    VStack(alignment: .leading) {
                        Map(
                            coordinateRegion: .constant(region),
                            interactionModes: [],
                            userTrackingMode: .constant(.none),
                            annotationItems: [place]
                        ) { place in
                            MapMarker(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: place.lat,
                                    longitude: place.lng
                                ),
                                tint: Color.accentColor
                            )
                        }
                        .frame(height: 180)
                        .cornerRadius(8)
                        VStack(alignment: .leading) {
                            if let name = place.name {
                                Text(name)
                                    .font(.title3)
                                    .bold()
                                Spacer().frame(height: 12)
                            }
                            let logs = model.histories[place]
                            if let logs = logs, !logs.isEmpty {
                                if logs.count > 10 {
                                    Text("VisitingHistory (Ten)")
                                        .bold()
                                } else {
                                    Text("VisitingHistory")
                                        .bold()
                                }
                                VStack {
                                    ForEach(logs.prefix(10)) { log in
                                        Button {
                                            moveToEditLogPage = log
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("VisitingTime")
                                                        .font(.callout)
                                                        .bold()
                                                        .foregroundColor(.secondary)
                                                    Spacer()
                                                    Text(log.visitedAt?.displayable ?? "Unknown")
                                                }
                                                HStack {
                                                    Text("DepartureTime")
                                                        .font(.callout)
                                                        .bold()
                                                        .foregroundColor(.secondary)
                                                    Spacer()
                                                    Text(log.exitedAt?.displayable ?? "Unknown")
                                                }
                                                Divider()
                                            }
                                        }
                                        .foregroundColor(Color(uiColor: .label))
                                    }
                                }
                                .padding()
                            } else {
                                Text("NoVisitingHistoryYet")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.secondary)
                                #if DEBUG
                                Button {
                                    let stub = InterestingPlaceVisitingLog(context: store.context)
                                    stub.visitedAt = Date()
                                    stub.place = place
                                    try! store.context.save()
                                } label: {
                                    Text("Visit")
                                }
                                .buttonStyle(.borderedProminent)
                                #endif
                            }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(8)
                    Spacer().frame(height: 12).background(Color(uiColor: .secondarySystemBackground))
                }
            }
        }
        .navigationTitle("RegisteredPlace")
        .partialSheet(isPresented: $moveToEditLogPage.isNotNil(), content: {
            if moveToEditLogPage != nil {
                EditInterestingPlaceVisitingLogView(log: $moveToEditLogPage)
            } else {
                EmptyView()
            }
        })
        .padding(4)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}
