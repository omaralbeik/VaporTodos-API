import Vapor
import FluentSQLite
import Crypto

struct TodoController: RouteCollection {

	func boot(router: Router) throws {
		let todosRoute = router.grouped(Path.todos)

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = todosRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

		// Create
		tokenAuthGroup.post(use: createHandler)

		// Read
		tokenAuthGroup.get(Todo.parameter, use: getHandler)
		tokenAuthGroup.get(use: getAllHandler)
		tokenAuthGroup.get(Path.search, use: searchHandler)

		// Update
		tokenAuthGroup.put(Todo.parameter, use: updateHandler)

		// Delete
		tokenAuthGroup.delete(Todo.parameter, use: deleteHandler)
	}

}

// MARK: - Handlers
private extension TodoController {

	func createHandler(_ req: Request) throws -> Future<Todo.Public> {
		let user = try req.requireAuthenticated(User.self)
		return try req.content.decode(Todo.CreateRequest.self).flatMap { todo in
			let todo = try Todo(title: todo.title, isDone: false, userId: user.requireID())
			try todo.validate()
			return todo.save(on: req).public
		}
	}

	func getHandler(_ req: Request) throws -> Future<Todo.Public> {
		let user = try req.requireAuthenticated(User.self)
		guard let todoId = req.parameters.values.first.flatMap({ Int($0.value) }) else {
			throw Abort(.badRequest)
		}

		return try user.children.query(on: req).filter(\.id == todoId).first().map(to: Todo.self) { possibleTodo in
			guard let todo = possibleTodo else {
				throw Abort(.notFound)
			}
			return todo
		}.public
	}

	func getAllHandler(_ req: Request) throws -> Future<[Todo.Public]> {
		let user = try req.requireAuthenticated(User.self)
		return try user.children.query(on: req).sort(\.dateCreated, .descending).decode(data: Todo.Public.self).all()
	}

	func searchHandler(_ req: Request) throws -> Future<[Todo.Public]> {
		let user = try req.requireAuthenticated(User.self)
		guard let query = req.query[String.self, at: "title"] else {
				throw Abort(.badRequest)
		}

		return try user.children.query(on: req).filter(\.title, .like, "%\(query)%").decode(data: Todo.Public.self).all()
	}

	func updateHandler(_ req: Request) throws -> Future<Todo.Public> {
		let user = try req.requireAuthenticated(User.self)
		guard let todoId = req.parameters.values.first.flatMap({ Int($0.value) }) else {
			throw Abort(.badRequest)
		}

		let todo = try user.children.query(on: req).filter(\.id == todoId).first().map(to: Todo.self) { possibleTodo in
			guard let todo = possibleTodo else {
				throw Abort(.notFound)
			}
			return todo
		}

		return try flatMap(to: Todo.Public.self, todo, req.content.decode(Todo.UpdateRequest.self)) { todo, updateRequest in
			if let title = updateRequest.title {
				todo.title = title
			}
			if let isDone = updateRequest.isDone {
				todo.isDone = isDone
			}
			try todo.validate()
			return todo.save(on: req).public
		}
	}

	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		let user = try req.requireAuthenticated(User.self)
		guard let todoId = req.parameters.values.first.flatMap({ Int($0.value) }) else {
			throw Abort(.badRequest)
		}

		return try user.children.query(on: req).filter(\.id == todoId).first().flatMap(to: HTTPStatus.self) { possibleTodo in
			guard let todo = possibleTodo else {
				throw Abort(.notFound)
			}
			return todo.delete(on: req).transform(to: .ok)
		}
	}
	
}
