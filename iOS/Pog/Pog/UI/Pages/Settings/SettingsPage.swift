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

    @StateObject var model: SettingsModel

    @FocusState var focus: Bool
    

    var body: some View {
        NavigationView {
            Form {
                Section("AboutData") {
                    Button {
                        showTotallyDeleteLogsAlert = true
                    } label: {
                        Text("TotallyDeleteAllLogs")
                    }
                    Button {
                        showTotallyDeleteNotificationAlert = true
                    } label: {
                        Text("TotallyDeleteAllNotifications")
                    }
                }
                Section("AboutLocation") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("UpdateOnBackground")
                            Toggle(isOn: Binding(get: {
                                model.allowsBackgroundLocationUpdates
                            }, set: { isAccept in
                                model.updateBackgroundLocationUpdates(isAccepted: isAccept)
                            })) {
                            }.toggleStyle(.switch)
                                .frame(width: 48)
                        }
                        Text("MessageAboutUpdateOnBackground")
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Accuracy_unit_meter")
                            TextField(NSLocalizedString("Default", comment: "") + "\(Int(Const.defaultDesiredAccuracy))", text: Binding(get: {
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
                                                Text("Close")
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
                        Text("Less the number is, more accurate recorded location is.")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Group {
                            Text("LocationAuthorizeStatus")
                            Spacer()
                            Text(model.locationAuthorizationStatus)
                        }.foregroundColor(.secondary)
                    }
                    HStack {
                        Group {
                            Text("LocationPrivacy")
                            Spacer()
                            Text(model.isAquiringAccuracyLocation)
                        }.foregroundColor(.secondary)
                    }
                    Button {
                        UIApplication.shared.open(
                            URL(string: UIApplication.openSettingsURLString)!
                        )
                    } label: {
                        Text("ConfirmWithSettings")
                    }
                }
                Section("AboutPog") {
                    Button {
                        shouldOnboarding = true
                    } label: {
                        Text("AboutPogFeatures")
                    }
                }
                Section("Feedback") {
                    Button {
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        SKStoreReviewController.requestReview(in: scene)
                    } label: {
                        Text("ReviewPog")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            model.onAppear()
        }
        .alert("DoesDeleteAllLogsTotally", isPresented: $showTotallyDeleteLogsAlert) {
            Button(role: .destructive) {
                model.totallyDeleteLogs()
            } label: {
                Text("Delete")
            }
            Button(role: .cancel, action: { }) {
                Text("Cancel")
            }
        }
        .alert("DoesDeleteAllNotificationTotally", isPresented: $showTotallyDeleteNotificationAlert) {
            Button(role: .destructive) {
                model.totallyDeleteInterestingPlaces()
            } label: {
                Text("Delete")
            }

        }
    }
}
