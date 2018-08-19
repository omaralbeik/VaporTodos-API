import Foundation

import FluentSQLite
import Vapor

final class Todo: Content, Parameter, SQLiteModel {

	/// The unique identifier for this `Todo`.
	var id: Int?

	/// A title describing what this `Todo` entails.
	var title: String

	/// Reference to user that owns this todo.
	var userId: User.ID

	init(id: Int? = nil, title: String, userId: User.ID) {
		self.id = id
		self.title = title
		self.userId = userId
	}

}

extension Todo {

	var user: Parent<Todo, User> {
		return parent(\.userId)
	}

}

extension Todo: Validatable {

	static func validations() throws -> Validations<Todo> {
		var validations = Validations(Todo.self)
		try validations.add(\.title, .count(1...))
		return validations
	}

}

extension Todo: Migration {

	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(Todo.self, on: connection) { builder in
			try addProperties(to: builder)
			builder.reference(from: \.userId, to: \User.id)
		}
	}

}

extension Todo {

	struct CreateRequest: Content {
		var title: String
	}

}

extension Todo: PublicType {

	struct Public: Content {
		var id: Int?
		var title: String
	}

	typealias P = Todo.Public
	var `public`: P {
		return P(id: id, title: title)
	}

}
