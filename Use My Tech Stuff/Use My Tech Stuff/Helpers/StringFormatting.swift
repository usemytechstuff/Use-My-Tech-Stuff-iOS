//
//  StringFormatting.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct StringFormatting {
	static func formatBrandAndModel(brand: String?, model: String?) -> String {
		if let brand = brand, let model = model {
			return "\(brand) - \(model)"
		}

		if let brand = brand {
			return brand
		}

		if let model = model {
			return model
		}

		return ""
	}

	static func formatPrice(withIntValue value: Int) -> String {
		let dollars = value / 100
		let cents = value % 100
		let centsStr = String(format: "%02d", cents)
		let outStr = "$\(dollars).\(centsStr)"
		return outStr
	}
}
