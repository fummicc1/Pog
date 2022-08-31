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

    @State private var showSelectDatePicker: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    MapViewRepresentable(
                        region: $model.region,
                        polyline: Binding(projectedValue: $model.selectedPolyline),
                        pickedUpLogs: $model.featuredLogs
                    )
                }
                .toolbar {
                    Button {
                        showSelectDatePicker = true
                    } label: {
                        Text(L10n.Common.selectDate)
                    }
                }
                .partialSheet(isPresented: $showSelectDatePicker) {
                    ScrollView {
                        if model.dates.isEmpty {
                            HStack {
                                Spacer()
                                Text(L10n.PlaceLogPage.Place.empty)
                                    .font(.title)
                                    .foregroundColor(Asset.secondaryTextColor.swiftUIColor)
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showSelectDatePicker = false
                            }
                        } else {
                            LazyVGrid(columns: [GridItem()], spacing: 8) {
                                ForEach(model.dates) { date in
                                    HStack {
                                        if date == model.selectedDate {
                                            Image(systemSymbol: .checkmark)
                                        }
                                        Text(date, style: .date)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Asset.secondaryBackgroundColor.swiftUIColor)
                                    .cornerRadius(12)
                                    .contentShape(RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture {
                                        model.onSelect(date: date)
                                        showSelectDatePicker = false
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxHeight: proxy.size.height * 0.4)
                }
            }
            .navigationTitle(model.selectedDate?.displayable(withTime: false) ?? L10n.Common.log)
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        }
        .onAppear {
            model.onApepar()
        }
    }
}
