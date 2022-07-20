//
//  WalkthroughPage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/06/26.
//

import SwiftUI
import CoreLocation

struct WalkthroughPage: View {

    @State private var selectedIndex: Int = 0

    @Binding var shouldOnboarding: Bool

    @Environment(\.locationManager) var locationManager: LocationManager

    @State private var locationAuthorizeStatus: CLAuthorizationStatus = .notDetermined

    var body: some View {
        VStack {
            Picker("", selection: $selectedIndex) {
                Text("WhatIsPog")
                    .tag(0)
                Text("AboutNotificationFeature")
                    .tag(1)
                Text("AboutLocationTrackingFeature")
                    .tag(2)
            }.pickerStyle(.segmented)
                .padding()

            TabView(selection: $selectedIndex) {
                page1
                    .tag(0)
                page2
                    .tag(1)
                page3
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onReceive(locationManager.authorizationStatus) { status in
            locationAuthorizeStatus = status
        }
        .onAppear {
            locationManager.request()
        }
    }

    var page1: some View {
        VStack {
            Text("WhatIsPog_1/3")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text("WhatIsPog_1/3")
            Text("")
            VStack {
                Image("page1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                if locationAuthorizeStatus != .authorizedAlways {
                    Button {
                        UIApplication.shared.open(
                            URL(string: UIApplication.openSettingsURLString)!
                        )
                    } label: {
                        Text("位置情報の取得を常に許可する")
                            .bold()
                    }
                } else {
                    Label("位置情報の取得が常に許可されています", systemSymbol: .checkmark)
                }
            }
            .padding(.bottom, 12)
        }
        .padding()
    }

    var page2: some View {
        VStack {
            Text("通知機能について（2/3）")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text("「マップ」画面から登録した場所が現在地から300メートル以内にいる場合、アプリから通知が届くことが出来ます。")
            Image("page2")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding()
    }

    var page3: some View {
        VStack {
            Text("位置情報ログ機能について（3/3）")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text("ユーザーの位置情報を常に記録してくれる機能について紹介します。iOSの設定からPogの位置情報を「常に許可」にすることによってログ追跡が行われます。また、時間が一定時間経過したり、距離の移動が起きた際のログはピンとしても表示されます。")
            Image("page3")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Button {
                shouldOnboarding = false
            } label: {
                HStack {
                    Spacer()
                    Text("完了")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct WalkthroughPage_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughPage(
            shouldOnboarding: .constant(true)
        )
    }
}
