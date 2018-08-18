import Foundation

import FluentSQLite
import Vapor

final class Todo {

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

extension Todo: Content {}
extension Todo: Parameter {}
extension Todo: SQLiteModel {}

extension Todo {
	var user: Parent<Todo, User> {
		return parent(\.userId)
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

extension Todo {

	final class Public: Content {
		var id: Int?
		var title: String

		init(id: Int?, title: String) {
			self.id = id
			self.title = title
		}
	}

}

extension Todo {

	var `public`: Public {
		return Todo.Public(id: id, title: title)
	}

}

extension Future where T: Todo {

	var `public`: Future<Todo.Public> {
		return map(to: Todo.Public.self) { return $0.public }
	}

}
