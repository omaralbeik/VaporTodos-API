//
//  UserToken+Public.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Vapor
import FluentSQLite

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
