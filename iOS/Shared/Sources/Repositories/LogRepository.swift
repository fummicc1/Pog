//
//  LogRepository.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/21.
//

import Foundation
import Models

public enum LogRepositoryError: Error {
	case notFound(id: LogId)
}

public protocol LogRepository {
	func add(location: Location, to logId: LogId) async throws
	func load(id: LogId, useCache: Bool) async throws -> Log
	func loadNext(of log: Log, useCache: Bool) async throws -> Log?
}
