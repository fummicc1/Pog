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

    var body: some View {
        if model.places.isEmpty {
            Text("登録された場所が見つかりませんでした")
        }
        List {
            ForEach(model.places) { place in
                let region: MKCoordinateRegion = .init(
                    center: CLLocationCoordinate2D(
                        latitude: place.lat,
                        longitude: place.lng
                    ),
                    span: .init(
                        latitudeDelta: 0.0005,
                        longitudeDelta: 0.0005
                    )
                )
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
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
                        .frame(height: 120)
                        .cornerRadius(8)
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        if let name = place.name {
                            Text(name)
                                .font(.title3)
                                .bold()
                            Spacer().frame(height: 12)
                        }
                        let logs = model.histories[place]
                        if let logs = logs, !logs.isEmpty {
                            if logs.count > 5 {
                                Text("• 訪問履歴（5件）")
                                    .bold()
                            } else {
                                Text("• 訪問履歴")
                                    .bold()
                            }
                            VStack {
                                ForEach(logs.prefix(5)) { log in
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
                }
                .padding()
                .cornerRadius(8)
                Spacer().frame(height: 4)
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle("登録済みの場所")
    }
}
