# VaporTodos API
Todos API using Vapor


## Project Structure

- [**Models**](https://github.com/omaralbeik/VaporTodos-API/tree/master/Sources/App/Models)
    - `PublicType.swift` protocol used to create Public responses for models.
    - `Token.swift` Token model.
    - `User.swift` User model.
    - `Todo.swift` Todo model.
- [**Controllers**](https://github.com/omaralbeik/VaporTodos-API/tree/master/Sources/App/Controllers)
    - `AuthController.swift` handles creating users and logging in.
    - `TodoController.swift` handles CRUD operations on Todo items.
    - `UserController.swift` handles listing user's todo items.
- [`Path.swift`](https://github.com/omaralbeik/VaporTodos-API/blob/master/Sources/App/Path.swift) URL pathes used in controllers.
- **Vapor Files** automatically created by Vapor.
    - `app.swift`
    - `boot.swift`
    - `configure.swift`
    - `routes.swift`

## Endpoints

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/e354821267d00e361187)

| Endpoint            | Method   | Description               | Authorization Type |
|:--------------------|:---------|:--------------------------|:-------------------|
| `api/auth/register` | `POST`   | Create new account        | None               |
| `api/auth/login`    | `POST`   | Get access token          | Basic              |
| `api/users`         | `GET`    | Get a list of users       | Bearer             |
| `api/users`         | `PUT`    | Update current user info  | Bearer             |
| `api/todos`         | `POST`   | Create new todo item      | Bearer             |
| `api/todos`         | `GET`    | Get all user's todo items | Bearer             |
| `api/todos/<id>`    | `GET`    | Get todo item             | Bearer             |
| `api/todos/<id>`    | `PUT`    | Update todo item          | Bearer             |
| `api/todos/<id>`    | `DELETE` | Delete todo item          | Bearer             |


## Requirements

- Vapor 3
- Linux Ubuntu 14.04+ / macOS with Xcode 9.3+ 
- Swift 4+


## License

VaporTodos is released under the MIT license. See [LICENSE](https://github.com/omaralbeik/VaporTodos-API/blob/master/LICENSE) for more information.