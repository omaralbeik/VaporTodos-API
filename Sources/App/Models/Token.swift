import Authentication
import Crypto
import FluentSQLite
import Vapor

final class Token: Content, Parameter {

	/// Token's unique identifier.
	var id: Int?

	/// Unique token string.
	var token: String

	/// Expiration date. Token will no longer be valid after this point.
	var expiresAt: Date?

	/// Reference to user that owns this token.
	var userId: User.ID

	init(id: Int? = nil, token: String, userId: User.ID) {
		self.id = id
		self.token = token

		// set token to expire after 30 days
		self.expiresAt = Date.init(timeInterval: 60 * 60 * 24 * 30, since: .init())

		self.userId = userId
	}

}

// MARK: - SQLiteModel
extension Token: SQLiteModel {

	static var deletedAtKey: TimestampKey? {
		return \.expiresAt
	}

}

// MARK: - Parent
extension Token {

	static func create(userId: User.ID) throws -> Token {
		let token = try CryptoRandom().generateData(count: 64).base64EncodedString()
		return .init(token: token, userId: userId)
	}

	var user: Parent<Token, User> {
		return parent(\.userId)
	}

}

// MARK: - Authentication
extension Token: Authentication.Token {

	typealias UserType = User

	static var tokenKey: WritableKeyPath<Token, String> {
		return \.token
	}

	static var userIDKey: WritableKeyPath<Token, User.ID> {
		return \.userId
	}

}

// MARK: - Migration
extension Token: Migration {

	static func prepare(on conn: SQLiteConnection) -> Future<Void> {
		return SQLiteDatabase.create(Token.self, on: conn) { builder in
			try addProperties(to: builder)
			builder.reference(from: \.userId, to: \User.id)
		}
	}

}

// MARK: - PublicType
extension Token: PublicType {

	struct Public: Content {
		var token: String
		var expiresAt: Date?
		var userId: User.ID
	}

	typealias P = Public
	var `public`: P {
		return P(token: token, expiresAt: expiresAt, userId: userId)
	}

}
