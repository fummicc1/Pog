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
                Text(L10n.WalkthroughPage.Page.pog)
                    .tag(0)
                Text(L10n.WalkthroughPage.Page.notification)
                    .tag(1)
                Text(L10n.WalkthroughPage.Page.aboutLocationTrackingFeature)
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
            Text(L10n.WalkthroughPage.First.title)
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text(L10n.WalkthroughPage.First.headline)
            Text(L10n.WalkthroughPage.First.message)
            VStack {
                Asset.page1.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                if locationAuthorizeStatus != .authorizedAlways {
                    Button {
                        UIApplication.shared.open(
                            URL(string: UIApplication.openSettingsURLString)!
                        )
                    } label: {
                        Text(L10n.WalkthroughPage.First.authorizeAlwaysLocationRequest)
                            .bold()
                    }
                } else {
                    Label(L10n.WalkthroughPage.First.locationRequestIsAlwaysAuthorized, systemSymbol: .checkmark)
                }
            }
            .padding(.bottom, 12)
        }
        .padding()
    }

    var page2: some View {
        VStack {
            Text(L10n.WalkthroughPage.Second.title)
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text(L10n.WalkthroughPage.Second.message)
            Asset.page2.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding()
    }

    var page3: some View {
        VStack {
            Text(L10n.WalkthroughPage.Third.title)
                .font(.title2)
                .bold()
                .underline()
                .padding()
            Text(L10n.WalkthroughPage.Second.message)
            Asset.page3.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Button {
                shouldOnboarding = false
            } label: {
                HStack {
                    Spacer()
                    Text(L10n.Common.done)
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
