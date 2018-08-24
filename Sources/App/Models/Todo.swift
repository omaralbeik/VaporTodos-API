import Foundation

import FluentSQLite
import Vapor

final class Todo: Content, Parameter {

	/// The unique identifier for this `Todo`.
	var id: Int?

	/// A title describing what this `Todo` entails.
	var title: String

	/// Whether this `Todo` is done or not
	var isDone: Bool

	/// The date when this `Todo` was created
	var dateCreated: Date

	/// Reference to user that owns this todo.
	var userId: User.ID

	init(id: Int? = nil, title: String, isDone: Bool, userId: User.ID) {
		self.id = id
		self.title = title
		self.isDone = isDone
		self.userId = userId
		self.dateCreated = Date()
	}

}

// MARK: - SQLiteModel
extension Todo: SQLiteModel {}

// MARK: - Parent
extension Todo {

	var user: Parent<Todo, User> {
		return parent(\.userId)
	}

}

// MARK: - Validatable
extension Todo: Validatable {

	static func validations() throws -> Validations<Todo> {
		var validations = Validations(Todo.self)
		try validations.add(\.title, .count(1...))
		return validations
	}

}

// MARK: - Migration
extension Todo: Migration {

	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(Todo.self, on: connection) { builder in
			try addProperties(to: builder)
			builder.unique(on: \.title)
			builder.reference(from: \.userId, to: \User.id)
		}
	}

}

// MARK: - CreateRequest
extension Todo {

	struct CreateRequest: Content {
		var title: String
		var isDone: Bool?
	}

}

// MARK: - UpdateRequest
extension Todo {

	struct UpdateRequest: Content {
		var title: String?
		var isDone: Bool?
	}

}

// MARK: - PublicType
extension Todo: PublicType {

	struct Public: Content {
		var id: Int?
		var title: String
		var isDone: Bool
		var dateCreated: Date
	}

	typealias P = Todo.Public
	var `public`: P {
		return P(id: id, title: title, isDone: isDone, dateCreated: dateCreated)
	}

}
