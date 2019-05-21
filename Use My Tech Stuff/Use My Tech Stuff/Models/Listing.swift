//
//  Listing.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Listing: Codable {
	let itemId: Int
	let owner: Int
	let itemType: String
	let itemDescription: String
	let itemBrand: String
	let itemModel: String
	let imgURL: String
	let itemPrice: Int


	// should we do this much?
	let itemAvailability: Bool
	let renter: Int
}
