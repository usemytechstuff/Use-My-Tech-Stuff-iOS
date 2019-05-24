//
//  StuffTableHeaderView.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class StuffTableHeaderView: UIView {
	@IBOutlet var addItemButton: UIButton!
	@IBOutlet var headerTitleLabel: UILabel!

	func showButton(_ show: Bool = true) {
		addItemButton.isHidden = !show
	}
}
