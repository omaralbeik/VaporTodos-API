import Vapor
import Authentication
import Crypto

public func routes(_ router: Router) throws {
	let userController = UserController()
	try userController.boot(router: router)

	let todoController = TodoController()
	try todoController.boot(router: router)
}
