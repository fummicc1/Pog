//
//  Account.swift
//  
//
//  Created by Fumiya Tanaka on 2024/01/20.
//

import Foundation

public struct Account {
	public var id: String
	public var authenticationMethod: AuthenticationMethod

	public var isLoggedIn: Bool {
		authenticationMethod != .none
	}

	public init(id: String, authenticationMethod: AuthenticationMethod) {
		self.id = id
		self.authenticationMethod = authenticationMethod
	}

	public static func makeInitial() -> Account {
		Account(id: "", authenticationMethod: .none)
	}
}

public enum AuthenticationMethod: Equatable {
	case email(email: String, hashedPassword: String)
	case apple(appleId: String)
	case none
}
