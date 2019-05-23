//
//  Helpers.swift
//  renTech
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

extension UIViewController {
	static func listingDetailViewController() -> ListingDetailViewController? {
		guard let viewItemVCArray = Bundle.main.loadNibNamed("ListingDetailViewController",
															 owner: nil,
															 options: nil) as? [ListingDetailViewController],
			let viewItemVC = viewItemVCArray.first else { return nil }
		return viewItemVC
	}

	static func editListingDetailViewController() -> EditListingDetailViewController? {
		guard let editItemVCArray = Bundle.main.loadNibNamed("EditListingDetailViewController",
															 owner: nil,
															 options: nil) as? [EditListingDetailViewController],
			let editItemVC = editItemVCArray.first else { return nil }
		return editItemVC
	}
}

extension UIView {
	func wiggle() {
		let spring = { (finished: Bool) in
			UIView.animate(withDuration: 1,
						   delay: 0,
						   usingSpringWithDamping: 0.2,
						   initialSpringVelocity: 0,
						   options: [],
						   animations: {
							self.transform = .identity
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.1, animations: {
			self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
		}, completion: spring)
	}
}

extension NSNotification.Name {
	static let checkLoginNotificationName = NSNotification.Name(rawValue: "com.redeggproductions.renTech.checkLogin")
}


enum AppearanceHelper {
	static let rentechIndigo = UIColor(hue: 246/360, saturation: 89/100, brightness: 65/100, alpha: 1)
	static let rentechBlack = UIColor(hue: 248/360, saturation: 6/100, brightness: 25/100, alpha: 1)
	static let rentechWhite = UIColor(hue: 260/360, saturation: 12/100, brightness: 95/100, alpha: 1)
}
