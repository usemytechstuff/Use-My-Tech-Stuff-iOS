//
//  ViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var confirmPasswordTextField: UITextField!
	@IBOutlet var emailTextField: UITextField!

	@IBOutlet var loginTypeSelector: UISegmentedControl!
	@IBOutlet var loginButton: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()
	}


	@IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
	}
	
	@IBAction func loginButtonPressed(_ sender: UIButton) {
	}
	
}
