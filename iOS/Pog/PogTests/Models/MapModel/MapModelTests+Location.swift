//
//  MapModelTests+Location.swift
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

extension MapModelTests {
    @MainActor
    func test_show_current_usr_location() {
        let currentLocation = CLLocationCoordinate2D(latitude: 50, longitude: 120)
        locationManager.currentCoordinate = currentLocation
        model.onTapMyCurrentLocationButton()
        XCTAssertEqual(model.region.center, currentLocation)
    }

    @MainActor
    func test_selectPlace() {
        let selectablePlace = Stubs.places[0]
        model.selectPlace(selectablePlace)
        XCTAssertEqual(model.selectedPlace, selectablePlace)
        XCTAssertTrue(model.showPartialSheet)
    }

    @MainActor
    func test_deselectPlace() {
        model.selectPlace(nil)
        XCTAssertNil(model.selectedPlace)
        XCTAssertFalse(model.showPartialSheet)
    }
}
