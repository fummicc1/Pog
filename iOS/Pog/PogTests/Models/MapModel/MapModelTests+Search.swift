//
//  MapModelTests.swift
//  PogTests
//
//  Created by Fumiya Tanaka on 2022/07/15.
//

import XCTest
import CoreLocation
import Combine
// If `Missing required Module` error occures, this link will help me.
// https://stackoverflow.com/questions/58125428/missing-required-module-xyz-on-unit-tests-when-using-swift-package-manager
@testable import D_Pog


extension MapModelTests {
    func test_user_can_search() async {
        // MARK: Arrange
        // MARK: Store
        store.logsSubject.send([])
        store.interestingPlacesSubject.send([])
        var searchConfiguration = Stubs.searchConfiguration
        let searchPlaces = Stubs.places

        store.updateSearchConfigurationHandler = { keypath, value in
            if let keypath = keypath as? WritableKeyPath<SearchConfiguration, [String]> {
                searchConfiguration[keyPath: keypath] = value as! [String]
            } else if let keypath = keypath as? WritableKeyPath<SearchConfiguration, Int> {
                searchConfiguration[keyPath: keypath] = value as! Int
            } else if let keypath = keypath as? WritableKeyPath<SearchConfiguration, Date?> {
                searchConfiguration[keyPath: keypath] = value as! Date?
            }
        }

        // MARK: LocationManager
        let initialLocation = CLLocationCoordinate2D()
        locationManager.currentCoordinate = initialLocation
        // MARK: PlaceManager
        placeManager.searchHandler = { text, coordinate, useGooglePlacesApi in
            XCTAssertEqual(text, "Test")
            XCTAssertEqual(coordinate, initialLocation)
            XCTAssertEqual(useGooglePlacesApi, true)
            self.placeManager.placesPublisherSubject.send(searchPlaces)
        }

        // MARK: Model
        model.searchText = "Test"

        // MARK: Act
        await model.onSubmitTextField()

        // MARK: Assert
        XCTAssertEqual(searchConfiguration.searchedWords, ["Test"])
        XCTAssertEqual(searchConfiguration.numberOfSearchPerDay, 1)
        // Within 1 seconds
        XCTAssertLessThan(searchConfiguration.lastSearchedDate!.timeIntervalSince(Date()), 1)

        XCTAssertEqual(model.showPlaces, searchPlaces)
    }
}
