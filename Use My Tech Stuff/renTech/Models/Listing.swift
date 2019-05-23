//
//  Listing.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Listing: Codable, Equatable {
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
	var renter: Int?

	static func == (rhs: Listing, lhs: Listing) -> Bool {
		if rhs.id != nil || lhs.id != nil {
			return rhs.id == lhs.id
		}
		return lhs.title == rhs.title && lhs.description == rhs.description
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(owner, forKey: .owner)
		try container.encode(type, forKey: .type)
		try container.encode(description, forKey: .description)
		try container.encode(brand, forKey: .brand)
		try container.encode(model, forKey: .model)
		try container.encode(imgURL, forKey: .imgURL)
		try container.encode(price, forKey: .price)
		try container.encode(title, forKey: .title)
		try container.encode(availability, forKey: .availability)
		try container.encode(renter, forKey: .renter)
	}
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
	let item: Listing?
	let changes: Listing?
}
