//
//  PlaceLogPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import MapKit
import SwiftUI

struct PlaceLogPage: View {

    @StateObject var model: PlaceLogModel

    @State private var showSelectDatePicker: Bool = false
    @State private var showDeleteLogsConfirmanceAlert: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack {
                    VStack {
                        MapViewRepresentable(
                            region: $model.region,
                            polyline: Binding(
                                projectedValue: $model
                                    .selectedPolyline
                            ),
                            pickedUpLogs: $model.featuredLogs
                        )
                    }
                    VStack {
                        Spacer().frame(height: 12)
                        HStack {
                            Button {
                                showDeleteLogsConfirmanceAlert = true
                            } label: {
                                Label(
                                    L10n.PlaceLogPage.Buttons.deleteForSelectedDate,
                                    systemSymbol: .trash
                                )
                                .foregroundColor(Asset.backgroundColor.swiftUIColor)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Asset.errorColor.swiftUIColor)
                            .cornerRadius(12)
                            Spacer()
                        }
                        .padding(8)
                        Spacer()
                    }
                }
                .toolbar {
                    Button {
                        showSelectDatePicker = true
                    } label: {
                        Text(L10n.Common.selectDate)
                    }
                }
                .alert(
                    L10n.PlaceLogPage.Alert.DeleteConfirmance.title(
                        model.selectedDate.displayable(withTime: false)
                    ),
                    isPresented: $showDeleteLogsConfirmanceAlert,
                    actions: {
                        Button(L10n.Common.delete, role: .destructive) {
                            Task {
                                await model.deleteLogsForSelectedDate()
                            }
                        }
                    }
                )
                .partialSheet(isPresented: $showSelectDatePicker) {
                    ScrollView {
                        if model.dates.isEmpty {
                            HStack {
                                Spacer()
                                Text(
                                    L10n
                                        .PlaceLogPage
                                        .Place
                                        .empty
                                )
                                .font(.title)
                                .foregroundColor(
                                    Asset
                                        .secondaryTextColor
                                        .swiftUIColor
                                )
                                .bold()
                                Spacer()
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showSelectDatePicker =
                                    false
                            }
                        }
                        else {
                            LazyVGrid(
                                columns: [
                                    GridItem()
                                ],
                                spacing: 8
                            ) {
                                ForEach(model.dates) { date in
                                    HStack {
                                        if date
                                            == model
                                            .selectedDate
                                        {
                                            Image(
                                                systemSymbol:
                                                    .checkmark
                                            )
                                        }
                                        Text(
                                            date,
                                            style:
                                                .date
                                        )
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        Asset
                                            .secondaryBackgroundColor
                                            .swiftUIColor
                                    )
                                    .cornerRadius(
                                        12
                                    )
                                    .contentShape(
                                        RoundedRectangle(
                                            cornerRadius:
                                                12
                                        )
                                    )
                                    .onTapGesture {
                                        model
                                            .onSelect(
                                                date:
                                                    date
                                            )
                                        showSelectDatePicker =
                                            false
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxHeight: proxy.size.height * 0.4)
                }
            }
            .navigationTitle(model.selectedDate.displayable(withTime: false))
            .navigationBarTitleDisplayMode(
                NavigationBarItem.TitleDisplayMode.inline
            )
        }
    }
}
