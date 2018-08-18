import FluentSQLite
import Authentication
import Vapor

final class User: Content, Parameter, SQLiteUUIDModel {

	/// User's unique identifier.
	var id: UUID?

	/// User's full name.
	var name: String

	/// User's email address.
	var email: String

	/// BCrypt hash of the user's password.
	var password: String

	init(id: UUID? = nil, name: String, email: String, password: String) {
		self.id = id
		self.name = name
		self.email = email
		self.password = password
	}

}

extension User: BasicAuthenticatable {
	static var usernameKey: WritableKeyPath<User, String> = \.email
	static var passwordKey: WritableKeyPath<User, String> = \.password
}

extension User: TokenAuthenticatable {
	typealias TokenType = UserToken
}

extension User: Migration {
	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(User.self, on: connection) { builder in
			try addProperties(to: builder)
			builder.unique(on: \.email)
		}
	}
}

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
