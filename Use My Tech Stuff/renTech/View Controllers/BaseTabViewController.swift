//
//  BaseTabViewController.swift
//  renTech
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BaseTabViewController: UITabBarController {
	let techStuffController = TechStuffController()

	var loginObserver: NSObjectProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()

		viewControllers?.forEach {
			if let techAccess = $0 as? TechStuffAccessor {
				techAccess.techStuffController = techStuffController
			}
		}

		loginObserver = NotificationCenter.default.addObserver(forName: .checkLoginNotificationName,
															   object: nil,
															   queue: nil) { [weak self] _ in
			self?.checkLogin()
		}
	}

	deinit {
		if let loginObserver = loginObserver {
			NotificationCenter.default.removeObserver(loginObserver)
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		checkLogin()
	}

	private func checkLogin() {
		if techStuffController.bearer == nil {
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
