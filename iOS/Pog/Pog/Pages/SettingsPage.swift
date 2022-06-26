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
    @State private var stopTrackingLocationExceptForegroundMode = false

    @Environment(\.store) var store: Store
    @Environment(\.locationManager) var locationManager: LocationManager


    var body: some View {
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
            Section("アプリについて") {
                Button {
                    shouldOnboarding = true
                } label: {
                    Text("Pogについて")
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
        .alert("完全にログを消去しますか？", isPresented: $showTotallyDeleteLogsAlert) {
            Button(role: .destructive) {
                let log = PlaceLog.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
                let batchRequest = NSBatchDeleteRequest(fetchRequest: log)
                do {
                    try store.context.execute(batchRequest)
                    store.context.reset()
                } catch {
                    print(error)
                }
            } label: {
                Text("消去")
            }
            Button(role: .cancel, action: { }) {
                Text("キャンセル")
            }
        }
        .alert("完全に通知設定を消去しますか？", isPresented: $showTotallyDeleteNotificationAlert) {
            Button(role: .destructive) {
                let interests = InterestingPlace.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
                let batch = NSBatchDeleteRequest(fetchRequest: interests)
                do {
                    try store.context.execute(batch)
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    store.context.reset()
                } catch {
                    print(error)
                }
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            } label: {
                Text("消去")
            }

        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
