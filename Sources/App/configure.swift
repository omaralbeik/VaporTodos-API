import Vapor
import FluentSQLite
import Authentication

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

	// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

	let directoryConfig = DirectoryConfig.detect()
	services.register(directoryConfig)

	// Configure Fluents SQL provider
	try services.register(FluentSQLiteProvider())

	// Configure the authentication provider
	try services.register(AuthenticationProvider())


    var middlewares = MiddlewareConfig()
	middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)


	// Configure database
	var databaseConfig = DatabasesConfig()
	let databasePath = "\(directoryConfig.workDir)todo.db"
	let database = try SQLiteDatabase(storage: .file(path: databasePath))
	databaseConfig.add(database: database, as: .sqlite)
	services.register(databaseConfig)

	// Configure model migrations
    var migrations = MigrationConfig()
	migrations.add(model: User.self, database: .sqlite)
	migrations.add(model: UserToken.self, database: .sqlite)
	migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)

	var commandConfig = CommandConfig.default()
	commandConfig.useFluentCommands()
	services.register(commandConfig)
}
