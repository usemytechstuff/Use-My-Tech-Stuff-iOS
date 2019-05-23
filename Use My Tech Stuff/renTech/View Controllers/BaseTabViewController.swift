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
	var presentingLogin: Bool {
		return (presentedViewController as? LoginViewController) != nil ? true : false
	}
	var animate = false

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
			guard let self = self else { return }
			self.checkLogin(animated: self.animate)
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

	private func checkLogin(animated: Bool = false) {
		if techStuffController.bearer == nil && presentingLogin == false {
			guard let loginVC = UIStoryboard.main?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
				else { return }
			loginVC.techStuffController = techStuffController
			present(loginVC, animated: animated) { [weak self] in
				self?.selectedIndex = 0
				self?.animate = true
			}
		}
	}
}
