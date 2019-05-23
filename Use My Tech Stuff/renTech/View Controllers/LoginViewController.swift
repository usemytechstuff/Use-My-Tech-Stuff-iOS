//
//  LoginViewController.swift
//  renTech
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

class LoginViewController: UIViewController, TechStuffAccessor {

	var techStuffController: TechStuffController?

	var loginMode: LoginMode = .login {
		didSet {
			updateLoginFields()
		}
	}

	@IBOutlet var stackContainer: UIStackView!

	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var confirmPasswordTextField: UITextField!
	@IBOutlet var emailTextField: UITextField!

	@IBOutlet var loginTypeSelector: UISegmentedControl!
	@IBOutlet var loginButton: UIButton!

	// MARK: - init stuff
	override func viewDidLoad() {
		super.viewDidLoad()
		updateLoginFields(animate: false)
		uiMods()
	}

	func uiMods() {
//		usernameTextField.inset
	}

	// MARK: - user input
	@IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
		loginMode = LoginMode.getType(for: sender.selectedSegmentIndex)
	}

	@IBAction func loginButtonPressed(_ sender: UIButton) {
		for subview in stackContainer.subviews {
			if let control = subview as? UIControl {
				control.resignFirstResponder()
			}
		}
		performSelectedLoginOption()
	}

	private func performSelectedLoginOption() {
		switch loginMode {
		case .login:
			login()
		case .signUp:
			signUp()
		}
	}

	private func login() {
		guard let username = usernameTextField.text, !username.isEmpty else {
			usernameTextField.wiggle()
			return
		}
		guard username.count < 32 else {
			let alert = createSimpleAlert(withTitle: "Username error",
										  message: "Your username must be fewer than 32 characters.")
			present(alert, animated: true)
			return
		}
		guard let password = passwordTextField.text, !password.isEmpty else {
			passwordTextField.wiggle()
			return
		}
		guard password.count >= 8 else {
			let alert = createSimpleAlert(withTitle: "Weak Password", message: "Your password must be at least 8 characters.")
			present(alert, animated: true)
			return
		}

		techStuffController?.login(with: User(username: username, password: password),
								   completion: { [weak self] (result: Result<Bearer, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				DispatchQueue.main.async {
					let errorAlert = UIAlertController(error: error)
					self?.present(errorAlert, animated: true)
				}
				return
			}
			//sign in here
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.dismiss(animated: true, completion: nil)
			}
		})
	}

	private func signUp() {
		guard let username = usernameTextField.text, !username.isEmpty else {
			usernameTextField.wiggle()
			return
		}
		guard username.count < 32 else {
			let alert = createSimpleAlert(withTitle: "Username error",
										  message: "Your username must be fewer than 32 characters.")
			present(alert, animated: true)
			return
		}
		guard let password = passwordTextField.text, !password.isEmpty else {
			passwordTextField.wiggle()
			return
		}
		guard password.count >= 8 else {
			let alert = createSimpleAlert(withTitle: "Weak Password", message: "Your password must be at least 8 characters.")
			present(alert, animated: true)
			return
		}
		guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
			confirmPasswordTextField.wiggle()
			return
		}
		guard let email = emailTextField.text, email.isEmail else {
			emailTextField.wiggle()
			return
		}

		let user = User(username: username, password: password, email: email)
		techStuffController?.signUp(with: user, completion: { [weak self] (result: Result<Data, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				DispatchQueue.main.async {
					let errorAlert = UIAlertController(error: error)
					self?.present(errorAlert, animated: true)
				}
				return
			}
			//sign in here
			guard let self = self else { return }
			DispatchQueue.main.async { [weak self] in
				self?.loginMode = .login
				self?.performSelectedLoginOption()
			}
		})
	}

	// MARK: - custom ui stuff
	private func updateLoginFields(animate: Bool = true) {
		let animation: () -> Void
		switch loginMode {
		case .login:
			animation = { [weak self] in
				guard let self = self else { return }
				self.confirmPasswordTextField.isHidden = true
				self.confirmPasswordTextField.alpha = 0
				self.emailTextField.isHidden = true
				self.emailTextField.alpha = 0
				self.loginButton.setTitle("Login", for: .normal)
				self.loginTypeSelector.selectedSegmentIndex = self.loginMode.rawValue
				self.stackContainer.layoutSubviews()
			}
		case .signUp:
			animation = { [weak self] in
				guard let self = self else { return }
				self.confirmPasswordTextField.isHidden = false
				self.confirmPasswordTextField.alpha = 1
				self.emailTextField.isHidden = false
				self.emailTextField.alpha = 1
				self.loginButton.setTitle("Sign Up", for: .normal)
				self.loginTypeSelector.selectedSegmentIndex = self.loginMode.rawValue
				self.stackContainer.layoutSubviews()
			}
		}
		if animate {
			UIView.animate(withDuration: 1.0,
						   delay: 0,
						   usingSpringWithDamping: 0.3,
						   initialSpringVelocity: 0,
						   options: [],
						   animations: animation,
						   completion: nil)
		} else {
			animation()
		}
	}

//	private func wiggle(textField: UITextField) {
//
//		let spring = { (finished: Bool) in
//			UIView.animate(withDuration: 1,
//						   delay: 0,
//						   usingSpringWithDamping: 0.2,
//						   initialSpringVelocity: 0,
//						   options: [],
//						   animations: {
//							textField.transform = .identity
//			}, completion: nil)
//		}
//
//		UIView.animate(withDuration: 0.1, animations: {
//			textField.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//		}, completion: spring)
//	}

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

	private func createSimpleAlert(withTitle title: String, message: String? = nil) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
		return alert
	}
}

// MARK: - Mock data
extension LoginViewController {
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
}
