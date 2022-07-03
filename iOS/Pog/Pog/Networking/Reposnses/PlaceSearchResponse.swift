//
//  PlaceSearchResponse.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/03.
//

import Foundation

public struct PlaceSearchResponse: Codable {
    public var results: [Result]
    public var status: String
}

extension PlaceSearchResponse {
    public struct Result: Codable {
        public var formattedAddress: String
        public var geometry: Geometry

        public var icon: String
        public var iconBackgroundColor: String
        public var iconMaskBaseUri: String
        public var name: String
        public var placeId: String
        public var reference: String
        public var types: [String]
    }
}

extension PlaceSearchResponse.Result {
    public struct Geometry: Codable {

        public struct Location: Codable {
            public var lat: Double
            public var lng: Double
        }

        public struct Viewport: Codable {
            public var northeast: Location
            public var southwest: Location
        }

        public var location: Location
        public var viewport: Viewport
    }
}
