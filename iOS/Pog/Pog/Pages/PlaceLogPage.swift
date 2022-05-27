//
//  PlaceLogPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import SwiftUI
import MapKit


struct PlaceLogPage: View {

    @StateObject var model: PlaceLogModel

    @State private var isMapMode: Bool = true

    var body: some View {
        VStack {
            Picker("表示モード", selection: $isMapMode) {
                if let selectedDate = model.selectedDate {
                    Text(selectedDate, style: .date)
                        .tag(true)
                } else {
                    Text("マップ")
                        .tag(true)
                }
                Text("日付選択")
                    .tag(false)
            }.pickerStyle(.segmented)
                .padding()
            if isMapMode {
                MapViewRepresentable(
                    region: $model.region,
                    polyline: Binding(projectedValue: $model.selectedPolyline)
                )
            } else {
                GeometryReader { proxy in
                    List {
                        ForEach(model.dates) { date in
                            HStack {
                                if date == model.selectedDate {
                                    Image(systemSymbol: .checkmark)
                                }
                                Text(date, style: .date)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                model.onSelect(date: date)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            model.onApepar()
        }
    }
}
