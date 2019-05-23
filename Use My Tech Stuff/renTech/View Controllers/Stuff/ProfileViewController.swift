//
//  ProfileViewController.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, TechStuffAccessor {
	var techStuffController: TechStuffController?

	@IBOutlet var usernameLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateViews()
	}

	private func updateViews() {
		guard let bearer = techStuffController?.bearer else { return }
		usernameLabel.text = bearer.username
	}
}
