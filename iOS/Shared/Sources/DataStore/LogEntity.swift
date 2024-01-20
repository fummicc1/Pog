//
//  LogEntity.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/21.
//

import Foundation
import RealmSwift
import RealmSwiftMacro

@GenCrud
public class LogEntity: Object {
	@Persisted var id: String = UUID().uuidString
	@Persisted var title: String = ""
	@Persisted var createdAt: Date = Date()
	@Persisted var updatedAt: Date = Date()

	@Persisted var from: Date
	@Persisted var to: Date

	@Persisted var locations: List<LocationEntity>

	public init(
		id: String,
		title: String,
		createdAt: Date,
		updatedAt: Date,
		from: Date,
		to: Date,
		locations: List<LocationEntity> = .init()
	) {
		self.id = id
		self.title = title
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.from = from
		self.to = to
		self.locations = locations
	}
}

