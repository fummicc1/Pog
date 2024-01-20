//
//  CurrentLogAndLocations.swift
//
//
//  Created by Fumiya Tanaka on 2024/01/21.
//

import Foundation


public struct CurrentLogAndLocations {
	public var log: Log
	public var locations: [Location]

	public init(log: Log, locations: [Location]) {
		self.log = log
		self.locations = locations
	}
}
