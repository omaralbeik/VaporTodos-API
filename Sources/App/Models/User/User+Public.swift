//
//  User+Public.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Vapor
import FluentSQLite

extension User {

	final class Public: Content {
		var name: String
		var email: String

		init(name: String, email: String) {
			self.name = name
			self.email = email
		}
	}

}

extension User {

	var `public`: Public {
		return User.Public(name: name, email: email)
	}

}

extension Future where T: User {

	var `public`: Future<User.Public> {
		return map(to: User.Public.self) { return $0.public }
	}

}
