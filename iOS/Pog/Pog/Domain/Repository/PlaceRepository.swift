//
//  PlaceRepository.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/31.
//

import Foundation
import Combine


public protocol PlaceRepository {
    var onAddedInterestingPlace: AnyPublisher<Place, Never> { get }
    var onUpdatedInterestingPlace:

    func createInterestingPlace(lat: Double, lng: Double, name: String) async throws

    func searchPlaces(word: String, lat: Double, lng: Double) async throws -> [Place]
}

public class PlaceRepositoryImpl {
    private let store: Store
    private let placeManager: PlaceManager

    public init(store: Store, placeManager: PlaceManager) {
        self.store = store
        self.placeManager = placeManager
    }
}

extension PlaceRepositoryImpl: PlaceRepository {

}
