import Vapor
import FluentSQLite
import Crypto

struct UserController: RouteCollection {

	func boot(router: Router) throws {
		let usersRoute = router.grouped("users")

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.get(use: getAllHandler)
	}

}

// MARK: - Handlers
private extension UserController {

	func updateHandler(_ req: Request) throws -> Future<User.Public> {
		return try flatMap(to: User.Public.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updateUser in
			user.email = updateUser.email
			user.name = updateUser.name
			return user.save(on: req).public
		}
	}

	func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
		return User.query(on: req).decode(data: User.Public.self).all()
	}

}
