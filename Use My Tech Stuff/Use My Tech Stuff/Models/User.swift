//
//  User.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct User: Codable {
	let username: String
	let password: String
	var email: String?
}

struct Bearer: Decodable {
//	let id: Int
	let message: String?
	let token: String
}
