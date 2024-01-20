//
//  Stubs.swift
//  PogTests
//
//  Created by Fumiya Tanaka on 2022/07/15.
//

import Foundation

@testable import D_Pog

enum Stubs {

    static func createLat(from index: Int) -> Double {
        Double(45 - index)
    }

    static func createLng(from index: Int) -> Double {
        Double(140 - index)
    }

    static func createDate(from index: Int) -> Date {
        // 2022-07-15 21:47:26
        let ref = Date(timeIntervalSince1970: 1_657_889_246)
        return ref.addingTimeInterval(TimeInterval(-1 * 60 * 60 * index))
    }

    static var placeLogs: [PlaceLogData] {
        let logs: [PlaceLogData] = (0..<10).map { index in
            let log = PlaceLogData()
            log.lat = createLat(from: index)
            log.lng = createLng(from: index)
            log.date = createDate(from: index)
            return log
        }
        return logs
    }

    static var interestingPlaces: [InterestingPlaceData] {
        let places: [InterestingPlaceData] = (0..<10).map { index in
            let place = InterestingPlaceData()
            place.lat = createLat(from: index)
            place.lng = createLng(from: index)
            place.distanceMeter = Double((index + 1) * 10)
            place.name = "\(index)"
            place.icon = nil
            return place
        }
        return places
    }

    static var searchConfiguration: SearchConfiguration {
        var config = SearchConfiguration()
        config.lastSearchedDate = nil
        config.numberOfSearchPerDay = 0
        config.searchedWords = []
        return config
    }

    static var places: [Place] {
        var places = (0..<10).map { index in
            Place(
                lat: createLat(from: index),
                lng: createLng(from: index),
                name: "\(index)"
            )
        }
        return places
    }
}
