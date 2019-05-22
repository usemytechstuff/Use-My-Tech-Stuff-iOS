//
//  StuffTableViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class StuffTableViewController: UITableViewController, TechStuffAccessor {
	var techStuffController: TechStuffController?
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
		guard let editItemVCArray = Bundle.main.loadNibNamed("EditListingDetailViewController",
															 owner: nil,
															 options: nil) as? [EditListingDetailViewController],
			let editItemVC = editItemVCArray.first else { return }
		editItemVC.techStuffController = techStuffController
		editItemVC.mode = .creatingOwn
		navigationController?.pushViewController(editItemVC, animated: true)
	}
}
