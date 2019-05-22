//
//  Listing.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Listing: Codable {
	let id: Int
	let owner: Int
	let type: String
	let description: String
	let brand: String?
	let model: String?
	let imgURL: String?
	let price: Int
	let title: String

	// should we do this much?
	let availability: Bool
	let renter: Int?
}
