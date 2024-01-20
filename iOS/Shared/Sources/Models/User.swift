//
//  User.swift
//  
//
//  Created by Fumiya Tanaka on 2024/01/20.
//

import Foundation

public struct User {
	public var id: String
	public var account: Account

	public init(
		id: String,
		account: Account
	) {
		self.id = id
		self.account = account
	}

	public static func makeInitial() -> User {
		User(
			id: "",
			account: Account.makeInitial()
		)
	}
}
