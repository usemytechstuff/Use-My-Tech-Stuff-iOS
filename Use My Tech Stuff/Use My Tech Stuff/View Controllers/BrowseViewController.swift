//
//  BrowseViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BrowseNavViewController: UINavigationController, TechStuffAccessor {
	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		viewControllers.forEach {
			if let techStuff = $0 as? TechStuffAccessor {
				techStuff.techStuffController = techStuffController
			}
		}
	}
}

class BrowseViewController: UIViewController, TechStuffAccessor {

	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let techAccess = segue.destination as? TechStuffAccessor {
			techAccess.techStuffController = techStuffController
		}
	}
}
