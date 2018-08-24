import Vapor

enum Path {
	case api
	case auth
	case login
	case register
	case users
	case todos
	case search
}

// MARK: - PathComponentsRepresentable
extension Path: PathComponentsRepresentable {

	func convertToPathComponents() -> [PathComponent] {
		switch self {
		case .api:
			return ["api"]
		case .auth:
			return ["auth"]
		case .login:
			return ["login"]
		case .register:
			return ["register"]
		case .users:
			return ["users"]
		case .todos:
			return ["todos"]
		case .search:
			return ["search"]
		}
	}

}
