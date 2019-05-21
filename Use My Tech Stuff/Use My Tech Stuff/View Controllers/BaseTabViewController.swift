//
//  BaseTabViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BaseTabViewController: UITabBarController {
	let techStuffController = TechStuffController()

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		checkLogin()
	}

	private func checkLogin() {
		if techStuffController.bearer == nil {
			print("niled")
			performSegue(withIdentifier: "ShowLogin", sender: nil)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowLogin" {
			if let dest = segue.destination as? LoginViewController {
				dest.techStuffController = techStuffController
			}
		}
	}
}
