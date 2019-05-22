//
//  Listing.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Listing: Codable {
	let id: Int?
	let owner: Int
	let type: String
	let description: String
	var brand: String?
	var model: String?
	var imgURL: String?
	let price: Int
	let title: String

	// should we do this much?
	let availability: Bool
	let renter: Int?
}

extension Listing {
	init(owner: Int, type: String, description: String, price: Int, title: String, availability: Bool) {
		self.owner = owner
		self.type = type
		self.description = description
		self.price = price
		self.title = title
		self.availability = availability

		id = nil
		brand = nil
		model = nil
		imgURL = nil
		renter = nil
	}
}

struct ListingResponse: Codable {
	let message: String
	let item: Listing
}
