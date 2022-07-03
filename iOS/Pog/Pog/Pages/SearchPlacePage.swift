//
//  SearchPlacePage.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import CoreData
import SwiftUI

struct SearchPlacePage: View {

    @Environment(\.managedObjectContext) var context
    @ObservedObject var model: SearchPlaceModel

    let place: Place

    var body: some View {
        VStack {
            Text(place.name)
                .font(.title3)
                .foregroundColor(Color(uiColor: .label))
                .bold()
            if let storedInterestingPlace = model.storedInterestingPlace {
                Text("現在地との距離が\(Int(storedInterestingPlace.distanceMeter))メートル以内に入ると通知がなります")
            }
            HStack {
                Button(model.alreadyInteresting ? "登録解除" : "登録") {
                    if model.alreadyInteresting {
                        if let placeToDelete = model.interestingPlaces.first(where: { $0.lat == place.lat && $0.lng == place.lng }) {
                            model.willDeleteInterestingPlace()
                            context.delete(placeToDelete)
                            model.storedInterestingPlace = nil
                        }
                        return
                    }
                    let interestingPlace = InterestingPlace(context: context)
                    interestingPlace.name = place.name
                    interestingPlace.lat = place.lat
                    interestingPlace.lng = place.lng
                    // TODO: Decide by user own.
                    interestingPlace.distanceMeter = 300
                    interestingPlace.visitedAt = Date()
                    do {
                        try context.save()
                        model.alreadyInteresting = true
                        model.storedInterestingPlace = interestingPlace
                        Task {
                            await model.didAddInterestingPlace()
                        }
                    } catch {
                        model.error = error.localizedDescription
                    }
                }
                .padding([.horizontal], 12)
                .padding([.vertical], 8)
                .background(.background)
                .cornerRadius(8)
            }
        }
        .padding()
        .alert("エラーが発生しました", isPresented: Binding(get: {
            model.error != nil
        }, set: { v in
            if !v {
                model.error = nil
            }
        })) {
            if let error = model.error {
                Text(error)
            }
        }
        .onAppear {
            if let stored = model.interestingPlaces.first(where: { place in
                place.lat == self.place.lat && place.lng == self.place.lng
            }) {
                model.storedInterestingPlace = stored
                model.alreadyInteresting = true
            } else {
                model.alreadyInteresting = false
            }
        }
    }
}
