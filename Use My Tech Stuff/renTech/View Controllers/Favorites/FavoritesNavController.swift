//
//  FavoritesNavController.swift
//  renTech
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class FavoritesNavController: UINavigationController, TechStuffAccessor {
	var techStuffController: TechStuffController?
	override func viewDidLoad() {
		super.viewDidLoad()
		viewControllers.forEach {
			if let techStuff = $0 as? TechStuffAccessor {
				techStuff.techStuffController = techStuffController
			}
		}
	}
}
