import Vapor
import FluentSQLite
import Crypto

struct AuthController: RouteCollection {

	func boot(router: Router) throws {
		let authRoute = router.grouped("auth")
		
		authRoute.post(User.self, at: "register", use: registerHandler)

		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
		let basicAuthGroup = authRoute.grouped(basicAuthMiddleware)
		basicAuthGroup.post("login", use: loginHandler)
	}

}

// MARK: - Handlers
private extension AuthController {

	func loginHandler(_ req: Request) throws -> Future<Token.Public> {
		let user = try req.requireAuthenticated(User.self)
		let token = try Token.create(userId: user.requireID())
		return token.save(on: req).public
	}

	func registerHandler(_ req: Request, user: User) throws -> Future<User.Public> {
		try user.validate()
		let digest = try req.make(BCryptDigest.self)
		let hashedPassword = try digest.hash(user.password)
		user.password = hashedPassword
		return user.save(on: req).public
	}

}
