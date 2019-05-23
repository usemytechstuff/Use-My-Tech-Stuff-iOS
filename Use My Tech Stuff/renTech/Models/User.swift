//
//  User.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct User: Codable {
	let id: Int?
	let username: String
	let password: String?
	var email: String?
	let firstname: String?
	let lastname: String?
	let phone: String?
	let address: String?

}

extension User {
	init(username: String, password: String) {
		self.init(id: nil,
				  username: username,
				  password: password,
				  email: nil,
				  firstname: nil,
				  lastname: nil,
				  phone: nil,
				  address: nil)
	}

	init(username: String, password: String, email: String) {
		self.init(id: nil,
				  username: username,
				  password: password,
				  email: email,
				  firstname: nil,
				  lastname: nil,
				  phone: nil,
				  address: nil)
	}
}

struct Bearer: Codable {
	let id: Int
	let message: String?
	let token: String
}
