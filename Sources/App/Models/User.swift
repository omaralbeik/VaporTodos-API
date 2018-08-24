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

extension User {

	var children: Children<User, Todo> {
		return children(\.userId)
	}

}

extension User: BasicAuthenticatable {

	static var usernameKey: WritableKeyPath<User, String> = \.email
	static var passwordKey: WritableKeyPath<User, String> = \.password

}

extension User: TokenAuthenticatable {

	typealias TokenType = Token

}

extension User: Validatable {

	static func validations() throws -> Validations<User> {
		var validations = Validations(User.self)
		try validations.add(\.email, .email)
		try validations.add(\.password, .count(6...) && .alphanumeric)
		return validations
	}

}

extension User: Migration {

	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(User.self, on: connection) { builder in
			try addProperties(to: builder)
			builder.unique(on: \.email)
		}
	}

}

extension User: PublicType {

	struct Public: Content {
		var name: String
		var email: String
	}

	typealias P = Public
	var `public`: P {
		return P(name: name, email: email)
	}

}
