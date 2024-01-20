//
//  Location.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/20.
//

import Foundation

public struct Location {
	public var id: String
	public var name: String
	public var coordinate: Coordinate

	public init(
		id: String,
		name: String,
		coordinate: Coordinate
	) {
		self.id = id
		self.name = name
		self.coordinate = coordinate
	}

	public static func makeInitial(coordinate: Coordinate) -> Location {
		Location(
			id: UUID().uuidString,
			name: "",
			coordinate: coordinate
		)
	}

	public struct Coordinate {
		public var latitude: Double
		public var longitude: Double

		public init(latitude: Double, longitude: Double) throws {
			guard latitude >= -90 && latitude <= 90 else {
				throw CoordinateError.invalidLatitude
			}
			guard longitude >= -180 && longitude <= 180 else {
				throw CoordinateError.invalidLongitude
			}
			self.latitude = latitude
			self.longitude = longitude
		}
	}
}

public enum CoordinateError: LocalizedError {
	case invalidLatitude
	case invalidLongitude

	public var errorDescription: String? {
		switch self {
		case .invalidLatitude:
			return "Latitude must be between -90 and 90"
		case .invalidLongitude:
			return "Longitude must be between -180 and 180"
		}
	}
}
