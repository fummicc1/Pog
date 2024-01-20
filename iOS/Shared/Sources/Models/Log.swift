//
//  Log.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/20.
//

import Foundation

public struct Log {
	public var id: LogId

	public var title: String

	public var previousLogId: LogId?
	public var nextLogId: LogId?

	public var createdAt: Date
	public var updatedAt: Date

	public var from: Date
	public var to: Date

	/// MARK: store last 100 locations
	public var recentLocations: [Location]

	public init(
		id: LogId,
		title: String,
		previousLogId: LogId? = nil,
		nextLogId: LogId? = nil,
		createdAt: Date,
		updatedAt: Date,
		from: Date,
		to: Date,
		recentLocations: [Location] = []
	) {
		self.id = id
		self.title = title
		self.previousLogId = previousLogId
		self.nextLogId = nextLogId
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		self.from = from
		self.to = to
		self.recentLocations = recentLocations
	}
}


public struct LogId: Hashable {
	public var id: String

	public init(id: String) {
		self.id = id
	}
}
