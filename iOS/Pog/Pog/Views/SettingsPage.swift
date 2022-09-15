//
//  SettingsPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/06/26.
//

import SwiftUI
import CoreData
import StoreKit

struct SettingsPage: View {

    @AppStorage("shouldOnboarding") var shouldOnboarding: Bool = false
    @State private var showTotallyDeleteLogsAlert: Bool = false
    @State private var showTotallyDeleteNotificationAlert: Bool = false
    @State private var showInquiryFormPage: Bool = false

    @StateObject var model: SettingsModel

    @FocusState var focus: Bool
    

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: InquiryFormPage(model: InquiryFormModel()),
                    isActive: $showInquiryFormPage
                ) {
                    EmptyView()
                }
                Form {
                    Section(L10n.SettingsPage.Data.about) {
                        Button {
                            showTotallyDeleteLogsAlert = true
                        } label: {
                            Text(L10n.SettingsPage.Data.totallyDeleteAllLogs)
                        }
                        Button {
                            showTotallyDeleteNotificationAlert = true
                        } label: {
                            Text(L10n.SettingsPage.Data.totallyDeleteAllNotifications)
                        }
                    }
                    Section(L10n.SettingsPage.Location.about) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(L10n.SettingsPage.Location.updateOnBackground)
                                Toggle(isOn: Binding(get: {
                                    model.allowsBackgroundLocationUpdates
                                }, set: { isAccept in
                                    model.updateBackgroundLocationUpdates(isAccepted: isAccept)
                                })) {
                                }.toggleStyle(.switch)
                                    .frame(width: 48)
                            }
                            if case SettingsModel.Selection.locationUpdateOnBackground = model.selection {
                                Text(L10n.SettingsPage.Location.messageAboutUpdateOnBackground)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            model.update(selection: .locationUpdateOnBackground)
                        }

                        VStack(alignment: .leading) {
                            HStack {
                                Text(L10n.SettingsPage.Location.accuracyUnitMeter)
                                TextField(L10n.Common.default + "\(Int(Const.defaultDesiredAccuracy))", text: Binding(get: {
                                    guard let desiredAccuracy = model.desiredAccuracy else {
                                        return ""
                                    }
                                    return "\(Int(desiredAccuracy))"
                                }, set: { desiredAccuracy in
                                    guard !desiredAccuracy.isEmpty, let desiredAccuracy = Double(desiredAccuracy) else {
                                        model.updateDesiredAccuracy(nil)
                                        return
                                    }
                                    model.updateDesiredAccuracy(desiredAccuracy)
                                }))
                                .keyboardType(.numberPad)
                                .focused($focus)
                                .toolbar {
                                    ToolbarItem(placement: .keyboard) {
                                        VStack {
                                            Button {
                                                focus = false
                                                model.commitDesiredAccuracyChange()
                                            } label: {
                                                Text(L10n.Common.close)
                                            }
                                        }
                                    }
                                }
                                .multilineTextAlignment(.trailing)
                                if focus {
                                    Button {
                                        model.updateDesiredAccuracy(nil)
                                    } label: {
                                        Image(systemSymbol: .multiplyCircleFill)
                                    }
                                }
                            }.buttonStyle(.plain)
                            if case SettingsModel.Selection.accuracy = model.selection {
                                Text(L10n.SettingsPage.Location.lessTheNumberIsMoreAccurateRecordedLocationIs)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            model.update(selection: .accuracy)
                        }

                        HStack {
                            Group {
                                Text(L10n.SettingsPage.Location.authorizeStatus)
                                Spacer()
                                Text(model.locationAuthorizationStatus)
                            }.foregroundColor(.secondary)
                        }
                        HStack {
                            Group {
                                Text(L10n.SettingsPage.Location.privacy)
                                Spacer()
                                Text(model.isAquiringAccuracyLocation)
                            }.foregroundColor(.secondary)
                        }
                        Button {
                            UIApplication.shared.open(
                                URL(string: UIApplication.openSettingsURLString)!
                            )
                        } label: {
                            Text(L10n.Common.confirmWithSettings)
                        }
                    }
                    Section(L10n.SettingsPage.Pog.about) {
                        Button {
                            shouldOnboarding = true
                        } label: {
                            Text(L10n.SettingsPage.Pog.aboutFeatures)
                        }
                    }
                    Section(L10n.SettingsPage.Pog.feedback) {
                        Button {
                            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                                return
                            }
                            SKStoreReviewController.requestReview(in: scene)
                        } label: {
                            Text(L10n.SettingsPage.Pog.review)
                        }
                        Button {
                            showInquiryFormPage = true
                        } label: {
                            Text(L10n.SettingsPage.Pog.inquiry)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            model.onAppear()
        }
        .alert(L10n.SettingsPage.Alert.doesDeleteAllLogsTotally, isPresented: $showTotallyDeleteLogsAlert) {
            Button(role: .destructive) {
                model.totallyDeleteLogs()
            } label: {
                Text(L10n.SettingsPage.Alert.delete)
            }
            Button(role: .cancel, action: { }) {
                Text(L10n.Common.cancel)
            }
        }
        .alert(L10n.SettingsPage.Alert.doesDeleteAllNotificationTotally, isPresented: $showTotallyDeleteNotificationAlert) {
            Button(role: .destructive) {
                model.totallyDeleteInterestingPlaces()
            } label: {
                Text(L10n.SettingsPage.Alert.delete)
            }

        }
    }
}
