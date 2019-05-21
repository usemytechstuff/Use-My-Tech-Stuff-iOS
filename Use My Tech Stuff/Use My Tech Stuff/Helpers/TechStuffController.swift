//
//  TechStuffController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

protocol TechStuffAccessor: AnyObject {
	var techStuffController: TechStuffController? { get set }
}

class TechStuffController {
	let networkHandler = NetworkHandler()

	var bearer: Bearer?

	var itemListings: [Listing] = []

	init() {
		loadData()
		getAllItems { (result: Result<Bool, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				print(error)
				if let netError = error as? NetworkError {
					switch netError {
					case .httpNon200StatusCode(let code, let data):
						print("code: \(code)")
						guard let data = data else { break }
						let dataStr = String(data: data, encoding: .utf8)
						print(dataStr)
					default:
						break
					}
				}
			}
		}
	}

	enum Endpoints: String {
		case signup = "/register"
		case login = "/login"
		case logout = "/logout"
		case items = "/items"
	}

	let baseURL = URL(string: "https://usemytechstuffapp.herokuapp.com/api")!

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

	func get(imageAtURL imageURLString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
		guard let imageURL = URL(string: imageURLString) else {
			// FIXME: Give better error (image url invalid)
			completion(.failure(.imageDecodeError))
			return
		}
		let request = URLRequest(url: imageURL)
		networkHandler.transferMahDatas(with: request, completion: { (result: Result<Data, NetworkError>) in
			do {
				let imageData = try result.get()
				guard let image = UIImage(data: imageData) else {
					completion(.failure(.imageDecodeError))
					return
				}
				completion(.success(image))
			} catch {
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		})
	}

	typealias BoolCompletion = (Result<Bool, NetworkError>) -> Void
	func getAllItems(completion: BoolCompletion? = nil) {
		guard let bearer = bearer else {
			// FIXME: perhaps change error here?
			completion?(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			return
		}
		let itemsURL = baseURL.appendingPathComponent(Endpoints.items.rawValue)

		var request = URLRequest(url: itemsURL)
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		networkHandler.transferMahCodableDatas(with: request) { (result: Result<[Listing], NetworkError>) in
			do {
				let listings = try result.get()
				self.itemListings = listings
				completion?(.success(true))
			} catch {
				completion?(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
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
