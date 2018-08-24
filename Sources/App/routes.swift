import Vapor
import Authentication
import Crypto

public func routes(_ router: Router) throws {
	let apiRouter = router.grouped(Path.api)

	let authController = AuthController()
	try authController.boot(router: apiRouter)

	let userController = UserController()
	try userController.boot(router: apiRouter)

	let todoController = TodoController()
	try todoController.boot(router: apiRouter)
}
