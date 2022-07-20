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
            Text("WhatIsPog_1/3_Headline")
            Text("WhatIsPog_1/3_Message")
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
                        Text("AuthorizeAlwaysLocationRequest")
                            .bold()
                    }
                } else {
                    Label("LocationRequestIsAlwaysAuthorized", systemSymbol: .checkmark)
                }
            }
            .padding(.bottom, 12)
        }
        .padding()
    }

    var page2: some View {
        VStack {
            Text("WhatIsPog_2/3")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text("WhatIsPog_2/3_Message")
            Image("page2")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding()
    }

    var page3: some View {
        VStack {
            Text("WhatIsPog_3/3")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text("WhatIsPog_3/3_Message")
            Image("page3")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Button {
                shouldOnboarding = false
            } label: {
                HStack {
                    Spacer()
                    Text("DONE")
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
