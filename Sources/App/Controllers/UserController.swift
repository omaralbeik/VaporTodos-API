//
//  UserController.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import Vapor
import FluentSQLite
import Crypto

struct UserController: RouteCollection {

	func boot(router: Router) throws {
		let usersRoute = router.grouped("api", "users")
		usersRoute.post(User.self, at: "register", use: registerHandler)

		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
		let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)
		basicAuthGroup.post("login", use: loginHandler)

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		tokenAuthGroup.get(use: getAllHandler)
	}

}

// MARK: - Handlers
private extension UserController {

	func loginHandler(_ request: Request) throws -> Future<UserToken.Public> {
		let user = try request.requireAuthenticated(User.self)
		let token = try UserToken.create(userId: user.requireID())
		return token.save(on: request).public
	}

	func updateHandler(_ request: Request) throws -> Future<User.Public> {
		return try flatMap(to: User.Public.self, request.parameters.next(User.self), request.content.decode(User.self)) { user, updateUser in
			user.email = updateUser.email
			user.name = updateUser.name
			return user.save(on: request).public
		}
	}

	func getAllHandler(_ request: Request) throws -> Future<[User.Public]> {
		return User.query(on: request).decode(data: User.Public.self).all()
	}

	func registerHandler(_ request: Request, user: User) throws -> Future<User.Public> {
		let digest = try request.make(BCryptDigest.self)
		let hashedPassword = try digest.hash(user.password)
		user.password = hashedPassword
		return user.save(on: request).public
	}

}
