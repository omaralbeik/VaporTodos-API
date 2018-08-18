//
//  UserToken.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Authentication
import Crypto
import FluentSQLite
import Vapor

final class UserToken: Content, Parameter {
	var id: Int?
	var token: String
	var expiresAt: Date?

	var userId: User.ID

	init(id: Int? = nil, token: String, userId: User.ID) {
		self.id = id
		self.token = token

		// set token to expire after 5 hours
		self.expiresAt = Date.init(timeInterval: 60 * 60 * 5, since: .init())

		self.userId = userId
	}
}

extension UserToken: SQLiteModel {
	static var deletedAtKey: TimestampKey? {
		return \.expiresAt
	}
}

extension UserToken {
	static func create(userId: User.ID) throws -> UserToken {
		let token = try CryptoRandom().generateData(count: 64).base64EncodedString()
		return .init(token: token, userId: userId)
	}

	var user: Parent<UserToken, User> {
		return parent(\.userId)
	}
}

extension UserToken: Token {
	typealias UserType = User

	static var tokenKey: WritableKeyPath<UserToken, String> {
		return \.token
	}

	static var userIDKey: WritableKeyPath<UserToken, User.ID> {
		return \.userId
	}
}

extension UserToken: Migration {
	static func prepare(on conn: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(UserToken.self, on: conn) { builder in
			try addProperties(to: builder)
			builder.reference(from: \.userId, to: \User.id)
		}
	}
}

extension UserToken {

	final class Public: Content {
		var token: String
		var expiresAt: Date?
		var userId: User.ID

		init(token: String, expiresAt: Date?, userId: User.ID) {
			self.token = token
			self.expiresAt = expiresAt
			self.userId = userId
		}
	}

}

extension UserToken {

	var `public`: Public {
		return UserToken.Public(token: token, expiresAt: expiresAt, userId: userId)
	}

}

extension Future where T: UserToken {

	var `public`: Future<UserToken.Public> {
		return map(to: UserToken.Public.self) { return $0.public }
	}

}
