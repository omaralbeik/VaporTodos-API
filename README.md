# VaporTodos API
Todos API using Vapor3 and Swift4


---

This repo is a part of my full-stack Swift tutorial:

- [**VaporTodos-API**](https://github.com/omaralbeik/VaporTodos-API) Vapor API (this repo)
- [**VaporTodos-iOS**](https://github.com/omaralbeik/VaporTodos-iOS) iOS Application 

---

## Getting Started

### 1. Install Vapor and Swift
a. For Ubuntu
```bash
eval "$(curl -sL https://apt.vapor.sh)"
sudo apt-get install swift vapor
eval "$(curl -sL check.vapor.sh)"
```

b. For macOS
```bash
brew install vapor
```

### 2. Build the project
```bash
vapor build
```
Please be patient, this might take several minutes for the first build 😅

### 2.1 Optionally Create an Xcode project if you are running on macOS
```bash
vapor xcode -y
```

### 3. Start the server
```bash
vapor run
```


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


## Requirements

- Vapor 3
- Linux Ubuntu 14.04+ / macOS with Xcode 9.3+ 
- Swift 4+


## License

VaporTodos is released under the MIT license. See [LICENSE](https://github.com/omaralbeik/VaporTodos-API/blob/master/LICENSE) for more information.