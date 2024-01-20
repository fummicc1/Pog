//
//  MapModelTests.swift
//  PogTests
//
//  Created by Fumiya Tanaka on 2022/07/15.
//

import Combine
import CoreLocation
import XCTest

// If `Missing required Module` error occures, this link will help me.
// https://stackoverflow.com/questions/58125428/missing-required-module-xyz-on-unit-tests-when-using-swift-package-manager
@testable import D_Pog

final class MapModelTests: XCTestCase {
    var model: MapModel!
    var locationManager: LocationManagerMock!
    var placeManager: PlaceManagerMock!
    var store: StoreMock!
    var cancellables: Set<AnyCancellable> = []

    @MainActor
    override func setUp() {
        super.setUp()
        locationManager = LocationManagerMock()
        placeManager = PlaceManagerMock()
        store = StoreMock()
        model = MapModel(
            locationManager: self.locationManager,
            placeManager: self.placeManager,
            store: self.store
        )
    }

    override func tearDown() {
        super.tearDown()
        cancellables.forEach {
            $0.cancel()
        }
    }
}
