//
//  LoginViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import SwiftyUtils

enum LoginMode: Int {
	case login
	case signUp

	static func getType(for value: Int) -> LoginMode {
		return LoginMode(rawValue: value) ?? .login
	}
}

class LoginViewController: UIViewController {

	// FIXME: remove initing here
	var techStuffController: TechStuffController? = TechStuffController()

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
		switch loginMode {
		case .login:
			login()
		case .signUp:
			signUp()
		}
	}

	private func login() {
		guard let username = usernameTextField.text, !username.isEmpty,
			let password = passwordTextField.text, !password.isEmpty else {
				wiggle(textField: passwordTextField)
				wiggle(textField: usernameTextField)
				return
		}
	}

	private func signUp() {
		guard let username = usernameTextField.text, !username.isEmpty else {
			wiggle(textField: usernameTextField)
			return
		}
		guard let password = passwordTextField.text, !password.isEmpty else {
			wiggle(textField: passwordTextField)
			return
		}
		guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
			wiggle(textField: confirmPasswordTextField)
			return
		}
		guard let email = emailTextField.text, email.isEmail else {
			wiggle(textField: emailTextField)
			return
		}

		let user = User(username: username, password: password, email: email)
		techStuffController?.signUp(with: user, completion: { (result: Result<Data, NetworkError>) in
			do {
				let data = try result.get()
				let str = String(data: data, encoding: .utf8)
				print(str)
			} catch {
				print("error getting result: \(error)")
				return
			}
		})
	}

	// FIXME: remove
	func setupMockDataSignUp() {
		techStuffController?.networkHandler.mockSuccess = true
		techStuffController?.networkHandler.mockMode = true

		let dataDict = ["username": "tester", "id": "1"]
		let encoder = JSONEncoder()
		do {
			techStuffController?.networkHandler.mockData = try encoder.encode(dataDict)
		} catch {
			print("error mocking data")
		}
	}

	// FIXME: remove
	func setupMockDataSignIn() {
		techStuffController?.networkHandler.mockSuccess = true
		techStuffController?.networkHandler.mockMode = true

		let dataDict = ["username": "tester", "token": "akdghaskjhfaskdjhfaskdgkajhsmd"]
		let encoder = JSONEncoder()
		do {
			techStuffController?.networkHandler.mockData = try encoder.encode(dataDict)
		} catch {
			print("error mocking data")
		}
	}

	private func updateLoginFields() {
		switch loginMode {
		case .login:
			// FIXME: remove
			setupMockDataSignIn()
			confirmPasswordTextField.isHidden = true
			emailTextField.isHidden = true
			loginButton.setTitle("Login", for: .normal)
			loginTypeSelector.selectedSegmentIndex = loginMode.rawValue
		case .signUp:
			// FIXME: remove
			setupMockDataSignUp()
			confirmPasswordTextField.isHidden = false
			emailTextField.isHidden = false
			loginButton.setTitle("Sign Up", for: .normal)
			loginTypeSelector.selectedSegmentIndex = loginMode.rawValue
		}
	}

	private func wiggle(textField: UITextField) {

		let spring = { (finished: Bool) in
			UIView.animate(withDuration: 1,
						   delay: 0,
						   usingSpringWithDamping: 0.2,
						   initialSpringVelocity: 0,
						   options: [],
						   animations: {
							textField.transform = .identity
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.1, animations: {
			textField.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
		}, completion: spring)
	}

	@IBAction func passwordFieldEdited(_ sender: UITextField) {
		if loginMode == .signUp {
			if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
				if password == confirmPassword {
					colorViewBorder(confirmPasswordTextField, color: .clear, borderWidth: 0)
				} else {
					colorViewBorder(confirmPasswordTextField, color: .red)
				}
			}
		}
	}

	@IBAction func emailFieldEdited(_ sender: UITextField) {
		if let email = sender.text {
			print(email)
			if email.isEmail {
				colorViewBorder(sender, color: .clear, borderWidth: 0)
			} else {
				colorViewBorder(sender, color: .red)
			}
		}
	}

	private func colorViewBorder(_ view: UIView, color: UIColor, borderWidth: CGFloat = 1) {
		view.layer.borderColor = color.cgColor
		view.layer.borderWidth = borderWidth
		view.layer.cornerRadius = 5
	}
}
