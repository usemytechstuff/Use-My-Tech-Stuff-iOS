//
//  TechStuffController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class TechStuffController {
	let networkHandler = NetworkHandler()

	var bearer: Bearer?

	init() {
		loadData()
	}


	enum Endpoints: String {
		case signup = "/register"
		case login = "/login"
		case logout = "/logout"
	}

	let baseURL = URL(string: "https://usemytechstuffapp.herokuapp.com/api/")!

	func signUp(with user: User, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		let signUpURL = baseURL.appendingPathComponent(Endpoints.signup.rawValue)

		var request = URLRequest(url: signUpURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(user)
		} catch {
			completion(.failure(.dataCodingError(specifically: error)))
			return
		}

		networkHandler.transferMahDatas(with: request, completion: completion)
	}

	func login(with user: User, completion: @escaping (Result<Bearer, NetworkError>) -> Void) {
		let loginURL = baseURL.appendingPathComponent(Endpoints.login.rawValue)

		var request = URLRequest(url: loginURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(user)
		} catch {
			completion(.failure(.dataCodingError(specifically: error)))
			return
		}
		networkHandler.transferMahCodableDatas(with: request) { [weak self] (result: Result<Bearer, NetworkError>) in
			do {
				let bearer = try result.get()
				self?.bearer = bearer
				completion(.success(bearer))
				self?.saveData()
			} catch {
				completion(.failure((error as? NetworkError) ?? NetworkError.otherError(error: error)))
			}
		}
	}

	private var fileURL: URL {
		let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		return documents.appendingPathComponent("techStuff.plist")
	}

	private func saveData() {
		let defaults = UserDefaults.standard
		let encoder = PropertyListEncoder()
		let data = try? encoder.encode(bearer)
		defaults.set(data, forKey: "user")
		// save favorites separately
	}

	private func loadData() {
		//load favorites separately
		let defaults = UserDefaults.standard
		let decoder = PropertyListDecoder()
		guard let data = defaults.data(forKey: "user") else { return }
		let bearer = try? decoder.decode(Bearer.self, from: data)
		self.bearer = bearer
	}
}
