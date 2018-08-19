import Vapor
import FluentSQLite
import Crypto

struct UserController: RouteCollection {

	func boot(router: Router) throws {
		let usersRoute = router.grouped("api", "users")

		let authRoute = router.grouped("api", "auth")
		authRoute.post(User.self, at: "register", use: registerHandler)

		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
		let basicAuthGroup = authRoute.grouped(basicAuthMiddleware)
		basicAuthGroup.post("login", use: loginHandler)

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.get(use: getAllHandler)
	}

}

// MARK: - Handlers
private extension UserController {

	func loginHandler(_ req: Request) throws -> Future<Token.Public> {
		let user = try req.requireAuthenticated(User.self)
		let token = try Token.create(userId: user.requireID())
		return token.save(on: req).public
	}

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

	func registerHandler(_ req: Request, user: User) throws -> Future<User.Public> {
		try user.validate()
		let digest = try req.make(BCryptDigest.self)
		let hashedPassword = try digest.hash(user.password)
		user.password = hashedPassword
		return user.save(on: req).public
	}
	
}
