//
//  InterestingPlaceVisitingListModel.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/08.
//

import Foundation
import SwiftUI


class InterestingPlaceVisitingListModel: ObservableObject {
    private let store: Store
    private let placeManager: PlaceManager

    @Published var histories: [InterestingPlace: [InterestingPlaceVisitingLog]] = [:]
    @Published var places: [InterestingPlace] = []

    init(store: Store, placeManager: PlaceManager) {
        self.store = store
        self.placeManager = placeManager

        store.interestingPlaces
            .receive(on: DispatchQueue.main)
            .assign(to: &$places)

        store.interestingPlaceVisitingLogs
            .map { logs in
                var histories: [InterestingPlace: [InterestingPlaceVisitingLog]] = [:]
                for log in logs {
                    guard let place = log.place else {
                        continue
                    }
                    if let current = histories[place] {
                        histories[place] = current + [log]
                    } else {
                        histories[place] = [log]
                    }
                }
                return histories
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$histories)
    }
}
