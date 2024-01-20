//
//  LogRepository.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/21.
//

import Foundation
import Models
import RealmSwift
import Repositories

public actor LogRepositoryImpl {

	var realm: Realm

	var logs: Results<LogEntity>?

	public init(realm: Realm) {
		self.realm = realm
		Task.detached {
			let logs = await self.realm.objects(LogEntity.self)
			await self.set(logs: logs)
		}
	}

	public init() throws {
		let realm = try Realm()
		self.init(realm: realm)
	}

	func set(logs: Results<LogEntity>) {
		self.logs = logs
	}
}

extension LogRepositoryImpl: LogRepository {
	public func add(location: Location, to logId: LogId) async throws {
		guard let logEntity = logs?.filter({ $0.id == logId.id }).first else {
			throw LogRepositoryError.notFound(id: logId)
		}
		let newLocationEntity = LocationEntity(
			id: location.id,
			createdAt: Date(),
			updatedAt: Date(),
			latitude: location.coordinate.latitude,
			longitude: location.coordinate.longitude
		)
		logEntity.locations.append(newLocationEntity)
	}

	public func load(id: LogId, useCache: Bool) async throws -> Log {
		if useCache {
			assertionFailure("Not implemented yet.")
		}
		guard let logEntity = logs?.filter({ $0.id == id.id }).first else {
			throw LogRepositoryError.notFound(id: id)
		}
		// TODO: Store in cache
		return Log(
			id: LogId(
				id: logEntity.id
			),
			title: logEntity.title,
			createdAt: logEntity.createdAt,
			updatedAt: logEntity.updatedAt,
			from: logEntity.from,
			to: logEntity.to
		)
	}

	public func loadNext(of log: Log, useCache: Bool) async throws -> Log? {
		fatalError()
	}


}
