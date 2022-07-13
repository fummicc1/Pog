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
            Text("登録された場所が見つかりませんでした")
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
                                    Text("• 訪問履歴（10件）")
                                        .bold()
                                } else {
                                    Text("• 訪問履歴")
                                        .bold()
                                }
                                VStack {
                                    ForEach(logs.prefix(10)) { log in
                                        Button {
                                            moveToEditLogPage = log
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("訪問時刻")
                                                        .font(.callout)
                                                        .bold()
                                                        .foregroundColor(.secondary)
                                                    Spacer()
                                                    Text(log.visitedAt?.displayable ?? "不明")
                                                }
                                                HStack {
                                                    Text("出発時刻")
                                                        .font(.callout)
                                                        .bold()
                                                        .foregroundColor(.secondary)
                                                    Spacer()
                                                    Text(log.exitedAt?.displayable ?? "不明")
                                                }
                                                Divider()
                                            }
                                        }
                                        .foregroundColor(Color(uiColor: .label))
                                    }
                                }
                                .padding()
                            } else {
                                Text("まだ訪問履歴はありません")
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
                                    Text("訪問する")
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
        .navigationTitle("登録済みの場所")
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
