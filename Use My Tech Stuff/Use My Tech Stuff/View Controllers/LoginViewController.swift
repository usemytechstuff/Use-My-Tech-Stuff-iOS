//
//  LoginViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

enum LoginMode: Int {
	case login
	case signUp

	static func getType(for value: Int) -> LoginMode {
		return LoginMode(rawValue: value) ?? .login
	}
}

class LoginViewController: UIViewController {

	// FIXME: remove initing here
	var networkHandler: NetworkHandler? = NetworkHandler()

	var loginMode: LoginMode = .login

	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var confirmPasswordTextField: UITextField!
	@IBOutlet var emailTextField: UITextField!

	@IBOutlet var loginTypeSelector: UISegmentedControl!
	@IBOutlet var loginButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		updateLoginFields()
	}

	@IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
		loginMode = LoginMode.getType(for: sender.selectedSegmentIndex)
		updateLoginFields()
	}

	@IBAction func loginButtonPressed(_ sender: UIButton) {
	}

	private func updateLoginFields() {
		switch loginMode {
		case .login:
			confirmPasswordTextField.isHidden = true
			emailTextField.isHidden = true
			loginButton.setTitle("Login", for: .normal)
			loginTypeSelector.selectedSegmentIndex = loginMode.rawValue
		case .signUp:
			confirmPasswordTextField.isHidden = false
			emailTextField.isHidden = false
			loginButton.setTitle("Sign Up", for: .normal)
			loginTypeSelector.selectedSegmentIndex = loginMode.rawValue
		}
	}

}
