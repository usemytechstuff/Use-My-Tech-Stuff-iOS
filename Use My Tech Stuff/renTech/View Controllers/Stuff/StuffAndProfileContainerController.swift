//
//  StuffAndProfileContainerController.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class StuffAndProfileContainerController: UIViewController, TechStuffAccessor {

	var techStuffController: TechStuffController?

	@IBOutlet var profileContainerView: UIView!
	@IBOutlet var stuffContainerView: UIView!

	override func viewDidLoad() {
        super.viewDidLoad()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? TechStuffAccessor {
			dest.techStuffController = techStuffController
		}
	}

	@IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
		techStuffController?.signOut()
	}
}
