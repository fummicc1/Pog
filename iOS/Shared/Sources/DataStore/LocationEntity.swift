//
//  LocationEntity.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/21.
//

import Foundation
import RealmSwift
import RealmSwiftMacro

@GenCrud
public class LocationEntity: Object {
	@Persisted var id: String = UUID().uuidString
	@Persisted var createdAt: Date = Date()
	@Persisted var updatedAt: Date = Date()
	
	@Persisted var latitude: Double = 0
	@Persisted var longitude: Double = 0

	public init(
		id: String,
		createdAt: Date,
		updatedAt: Date,
		latitude: Double,
		longitude: Double
	) {
		self.id = id
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.latitude = latitude
		self.longitude = longitude
	}
}
