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
                Section("データ関連") {
                    Button {
                        showTotallyDeleteLogsAlert = true
                    } label: {
                        Text("全てのログを消去する")
                    }
                    Button {
                        showTotallyDeleteNotificationAlert = true
                    } label: {
                        Text("全ての通知を消去する")
                    }
                }
                Section("位置情報関連") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("バックグラウンド更新")
                            Text("OFFにするとアプリが終了すると位置情報は記録されません")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle(isOn: Binding(get: {
                            model.allowsBackgroundLocationUpdates
                        }, set: { isAccept in
                            model.updateBackgroundLocationUpdates(isAccepted: isAccept)
                        })) {
                        }.toggleStyle(.switch)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("精度（単位: メートル）")
                            Text("精度よく記録するには\(Int(SettingsModel.Const.defaultDesiredAccuracy))以下がおすすめです")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        TextField("デフォルト: \(Int(SettingsModel.Const.defaultDesiredAccuracy))", text: Binding(get: {
                            guard let desiredAccuracy = model.desiredAccuracy else {
                                return ""
                            }
                            return "\(Int(desiredAccuracy))"
                        }, set: { desiredAccuracy in
                            if desiredAccuracy.isEmpty {
                                model.updateDesiredAccuracy(nil)
                            } else {
                                model.updateDesiredAccuracy(Double(desiredAccuracy)!)
                            }
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
                                            Text("閉じる")
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
                    HStack {
                        Group {
                            Text("位置情報の許可状態")
                            Spacer()
                            Text(model.locationAuthorizationStatus)
                        }.foregroundColor(.secondary)
                    }
                    HStack {
                        Group {
                            Text("正確な位置情報")
                            Spacer()
                            Text(model.isAquiringAccuracyLocation)
                        }.foregroundColor(.secondary)
                    }
                    Button {
                        UIApplication.shared.open(
                            URL(string: UIApplication.openSettingsURLString)!
                        )
                    } label: {
                        Text("設定アプリで確認する")
                    }
                }
                Section("アプリについて") {
                    Button {
                        shouldOnboarding = true
                    } label: {
                        Text("Pogについて（機能説明）")
                    }
                }
                Section("フィードバック") {
                    Button {
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        SKStoreReviewController.requestReview(in: scene)
                    } label: {
                        Text("Pogをレビューする")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            model.onAppear()
        }
        .alert("完全にログを消去しますか？", isPresented: $showTotallyDeleteLogsAlert) {
            Button(role: .destructive) {
                model.totallyDeleteLogs()
            } label: {
                Text("消去")
            }
            Button(role: .cancel, action: { }) {
                Text("キャンセル")
            }
        }
        .alert("完全に通知設定を消去しますか？", isPresented: $showTotallyDeleteNotificationAlert) {
            Button(role: .destructive) {
                model.totallyDeleteInterestingPlaces()
            } label: {
                Text("消去")
            }

        }
    }
}
