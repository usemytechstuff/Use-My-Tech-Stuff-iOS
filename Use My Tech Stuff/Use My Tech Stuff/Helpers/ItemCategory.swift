//
//  ItemCategory.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

enum ItemCategory: String, CaseIterable {
	case cameras
	case drones
	case headphones
	case projectors
	case screens
	case speakers
	case virtualReality

	static func getCategory(for value: Int) -> ItemCategory {
		if value < allCases.count {
			return allCases[value]
		} else {
			return .cameras
		}
	}

	static func getIndex(for category: ItemCategory?) -> Int {
		let defaultValue = 3
		guard let category = category else { return defaultValue }
		if let index = allCases.firstIndex(of: category) {
			return index
		} else {
			return defaultValue
		}
	}
}
