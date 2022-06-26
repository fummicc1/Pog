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
    @State private var showTotallyDeleteAlert: Bool = false
    @Environment(\.store) var store: Store


    var body: some View {
        Form {
            Section("設定") {
                Button {
                    showTotallyDeleteAlert = true
                } label: {
                    Text("全てのログを消去する")
                }
                Button {
                    let interests = NSFetchRequest<NSFetchRequestResult>(entityName: "InterestingPlace")
                    let batch = NSBatchDeleteRequest(fetchRequest: interests)
                    do {
                        try store.context.execute(batch)
                    } catch {
                        print(error)
                    }
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
            Section("応援・フィードバック") {
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
        .alert("完全にログを削除しますか？", isPresented: $showTotallyDeleteAlert) {
            Button(role: .destructive) {
                let log = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceLog")
                let batchRequest = NSBatchDeleteRequest(fetchRequest: log)
                do {
                    try store.context.execute(batchRequest)
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
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
