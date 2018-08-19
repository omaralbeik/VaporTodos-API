import FluentSQLite
import Authentication
import Vapor

protocol PublicType {

	associatedtype P: Content
	var `public`: P { get }

}

extension Future where T: PublicType {

	var `public`: Future<T.P> {
		return map(to: T.P.self) { return $0.public }
	}

}
