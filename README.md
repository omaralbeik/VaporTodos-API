# VaporTodos API
Todos API using Vapor

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