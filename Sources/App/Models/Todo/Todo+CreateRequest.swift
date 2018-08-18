//
//  Todo+CreateRequest.swift
//  App
//
//  Created by Omar Albeik on 8/18/18.
//

import FluentSQLite
import Vapor

extension Todo {
	
	struct CreateRequest: Content {
		var title: String
	}

}
