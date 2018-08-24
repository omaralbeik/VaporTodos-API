import Vapor
import FluentSQLite
import Crypto

struct UserController: RouteCollection {

	func boot(router: Router) throws {
		let usersRoute = router.grouped(Path.users)

		// Get all users
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.get(use: getAllHandler)
		tokenAuthGroup.put(use: updateHandler)
	}

}

// MARK: - Handlers
private extension UserController {

	func updateHandler(_ req: Request) throws -> Future<User.Public> {
		let user = try req.requireAuthenticated(User.self)
		return try req.content.decode(User.UpdateRequest.self).flatMap { updateRequest -> Future<User.Public> in
			if let email = updateRequest.email {
				user.email = email
			}
			if let name = updateRequest.name {
				user.name = name
			}
			if let password = updateRequest.password {
				let digest = try req.make(BCryptDigest.self)
				let hashedPassword = try digest.hash(password)
				user.password = hashedPassword
			}
			try user.validate()
			return user.save(on: req).public
		}
	}

	func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
		return User.query(on: req).decode(data: User.Public.self).all()
	}

}
