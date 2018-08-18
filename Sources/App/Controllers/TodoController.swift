import Vapor
import FluentSQLite
import Crypto

struct TodoController: RouteCollection {

	func boot(router: Router) throws {
		let todosRoute = router.grouped("api", "todos")

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = todosRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

		tokenAuthGroup.get(Todo.parameter, use: getHandler)
		tokenAuthGroup.get(use: getAllHandler)
		tokenAuthGroup.post(use: createHandler)
		tokenAuthGroup.delete(Todo.parameter, use: deleteHandler)
		tokenAuthGroup.put(Todo.parameter, use: updateHandler)
	}

}

// MARK: - Handlers
private extension TodoController {

	func getHandler(_ request: Request) throws -> Future<Todo.Public> {
		let user = try request.requireAuthenticated(User.self)
		return try request.parameters.next(Todo.self).map { todo in
			guard try todo.userId == user.requireID() else {
				throw Abort(.forbidden)
			}
			return todo
		}.public
	}

	func getAllHandler(_ request: Request) throws -> Future<[Todo.Public]> {
		let user = try request.requireAuthenticated(User.self)
		return try Todo.query(on: request).filter(\.userId == user.requireID()).decode(data: Todo.Public.self).all()
	}

	func createHandler(_ request: Request) throws -> Future<Todo.Public> {
		let user = try request.requireAuthenticated(User.self)
		return try request.content.decode(Todo.CreateRequest.self).flatMap { todo in
			return try Todo(title: todo.title, userId: user.requireID()).save(on: request).public
		}
	}

	func updateHandler(_ request: Request) throws -> Future<Todo.Public> {
		return try flatMap(to: Todo.Public.self, request.parameters.next(Todo.self), request.content.decode(Todo.CreateRequest.self)) { todo, updateData in
			todo.title = updateData.title
			return todo.save(on: request).public
		}
	}

	func deleteHandler(_ request: Request) throws -> Future<HTTPStatus> {
		let user = try request.requireAuthenticated(User.self)

		return try request.parameters.next(Todo.self).flatMap { todo -> Future<Void> in
			guard try todo.userId == user.requireID() else {
				throw Abort(.forbidden)
			}
			return todo.delete(on: request)
		}.transform(to: .ok)
	}

}
