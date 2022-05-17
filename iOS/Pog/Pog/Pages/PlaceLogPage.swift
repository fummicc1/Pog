//
//  PlaceLogPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import MapKit


struct PlaceLogPage: View {

    @ObservedObject var model: MapModel

    @State private var isMapMode: Bool = true

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "date", ascending: true)
    ]) var logs: FetchedResults<PlaceLog>

    var body: some View {
        VStack {
            Picker("表示モード", selection: $isMapMode) {
                Text("マップ")
                    .tag(true)
                Text("リスト")
                    .tag(false)
            }.pickerStyle(.segmented)
                .padding()
            if isMapMode {
                Map(
                    coordinateRegion: $model.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.none),
                    annotationItems: logs
                ) { log in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: log.lat,
                            longitude: log.lng
                        )
                    ) {
                        let color = Color(hexStr: log.color!)!
                        Image(systemSymbol: .pawprintFill)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(
                                color.opacity(0.2)
                            )
                    }
                }
            } else {
                List {
                    ForEach(logs) { log in
                        if let date = log.date {
                            Text(date, format: .dateTime)
                        }
                    }
                }
            }
        }
    }
}

struct PlaceLogListPage_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLogPage(model: MapModel(locationManager: LocationManagerImpl.shared))
    }
}
