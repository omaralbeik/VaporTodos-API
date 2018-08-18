//
//  Todo.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Foundation

import FluentSQLite
import Vapor

final class Todo: Content, Parameter {

	/// The unique identifier for this `Todo`.
	var id: Int?

	/// A title describing what this `Todo` entails.
	var title: String

	/// Reference to user that owns this TODO.
	var userId: User.ID

	init(id: Int? = nil, title: String, userId: User.ID) {
		self.id = id
		self.title = title
		self.userId = userId
	}
}

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
