//
//  Todo+Public.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Vapor
import FluentSQLite

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
