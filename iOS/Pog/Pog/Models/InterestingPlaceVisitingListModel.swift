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

    init(store: Store, placeManager: PlaceManager) {
        self.store = store
        self.placeManager = placeManager
    }


}
