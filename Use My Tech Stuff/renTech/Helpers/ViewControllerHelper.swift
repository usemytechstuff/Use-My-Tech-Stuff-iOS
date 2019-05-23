//
//  ViewControllerHelper.swift
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
