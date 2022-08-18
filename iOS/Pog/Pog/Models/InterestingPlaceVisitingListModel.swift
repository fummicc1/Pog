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

    @Published var histories: [InterestingPlaceData: [InterestingPlaceVisitingLogData]] = [:]
    @Published var places: [InterestingPlaceData] = []

    init(store: Store, placeManager: PlaceManager) {
        self.store = store
        self.placeManager = placeManager

        store.interestingPlaces
            .receive(on: DispatchQueue.main)
            .assign(to: &$places)

        store.interestingPlaceVisitingLogDatas
            .map { logs in
                logs.sorted { head, tail in
                    let tailVisitedAt = tail.visitedAt ?? Date(timeIntervalSince1970: 0)
                    let headVisitedAt = head.visitedAt ?? Date(timeIntervalSince1970: 0)
                    return headVisitedAt > tailVisitedAt
                }
            }
            .map { logs in
                var histories: [InterestingPlaceData: [InterestingPlaceVisitingLogData]] = [:]
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
