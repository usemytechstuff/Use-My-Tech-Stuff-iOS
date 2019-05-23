//
//  ViewControllerHelper.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

enum ViewControllerHelper {
	static func listingDetailViewController() -> ListingDetailViewController? {
		guard let viewItemVCArray = Bundle.main.loadNibNamed("ListingDetailViewController",
															 owner: nil,
															 options: nil) as? [ListingDetailViewController],
			let viewItemVC = viewItemVCArray.first else { return nil }
		return viewItemVC
	}
}

extension UIViewController {
	static func listingDetailViewController() -> ListingDetailViewController? {
		guard let viewItemVCArray = Bundle.main.loadNibNamed("ListingDetailViewController",
															 owner: nil,
															 options: nil) as? [ListingDetailViewController],
			let viewItemVC = viewItemVCArray.first else { return nil }
		return viewItemVC
	}
}
