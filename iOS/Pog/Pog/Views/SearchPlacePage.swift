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

    var body: some View {
        VStack {
            Text(model.place.name)
                .font(.title3)
                .foregroundColor(Color(uiColor: .label))
                .bold()
            if let storedInterestingPlace = model.storedInterestingPlace {
                Text("現在地との距離が\(Int(storedInterestingPlace.distanceMeter))メートル以内に入ると通知がなります")
            }
            HStack {
                Button(model.alreadyInteresting ? "登録解除" : "登録") {
                    // TODO: Logic should be deadled within `Model`.
                    if model.alreadyInteresting {
                        if let placeToDelete = model.interestingPlaces.first(where: { $0.lat == model.place.lat && $0.lng == model.place.lng }) {
                            model.willDeleteInterestingPlace()
                            context.delete(placeToDelete)
                            model.storedInterestingPlace = nil
                        }
                        return
                    }
                    let interestingPlace = InterestingPlace(context: context)
                    interestingPlace.name = model.place.name
                    interestingPlace.lat = model.place.lat
                    interestingPlace.lng = model.place.lng
                    // TODO: Decide by user own.
                    interestingPlace.distanceMeter = 300
                    interestingPlace.icon = model.place.icon
                    do {
                        try context.save()
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
                place.lat == model.place.lat && place.lng == model.place.lng
            }) {
                model.storedInterestingPlace = stored
                model.alreadyInteresting = true
            } else {
                model.alreadyInteresting = false
            }
        }
    }
}
