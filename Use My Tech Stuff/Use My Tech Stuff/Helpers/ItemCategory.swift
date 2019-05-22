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
	case miscellaneous

	static func getCategory(for value: Int) -> ItemCategory {
		if value < allCases.count {
			return allCases[value]
		} else {
			return .cameras
		}
	}

	static func getIndex(for category: ItemCategory?) -> Int {
		let defaultValue = 7
		guard let category = category else { return defaultValue }
		if let index = allCases.firstIndex(of: category) {
			return index
		} else {
			return defaultValue
		}
	}

	static func getCategory(for value: String) -> ItemCategory {
		let lower = value.lowercased()
		if let category = ItemCategory(rawValue: lower) {
			return category
		} else if let category = ItemCategory(rawValue: value) {
			return category
		}

		switch lower {
		case "camera":
			return .cameras
		case "drone":
			return .drones
		case "vr", "virtualreality":
			return .virtualReality
		case "headphone":
			return .headphones
		case "projector":
			return .projectors
		case "screen", "tv", "television":
			return .screens
		case "speaker":
			return .speakers
		default:
			return .miscellaneous
		}

	}
}
