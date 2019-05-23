//
//  TechStuffController.swift
//  renTech
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

	var itemListings: [Listing] = [] {
		didSet {
			updateDerivatives()
		}
	}

	init() {
		networkHandler.strict200CodeResponse = false
		loadData()
		refreshItems()
	}

	// MARK: - API stuff
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
			completion(.failure(.urlInvalid(urlString: imageURLString)))
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
			// FIXME: perhaps change error here? - reset to login screen
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
				self.itemListings = listings.sorted { $0.title < $1.title }
				completion?(.success(true))
			} catch {
				completion?(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	private func refreshItems() {
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
						print(dataStr as Any)
					default:
						break
					}
				}
			}
		}
	}

	func post(newItem item: Listing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			// FIXME: perhaps change error here? - reset to login screen
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			return
		}
		let itemsURL = baseURL.appendingPathComponent(Endpoints.items.rawValue)

		var request = URLRequest(url: itemsURL)
		request.httpMethod = HTTPMethods.post.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(item)
		} catch {
			completion(.failure(.dataCodingError(specifically: error)))
			return
		}

		networkHandler.transferMahCodableDatas(with: request) { [weak self] (result: Result<ListingResponse, NetworkError>) in
			self?.refreshItems()
			completion(result)
		}
	}

	func delete(existingItem item: Listing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			// FIXME: perhaps change error here? - reset to login screen
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			return
		}
		guard let itemID = item.id else { return }
		let itemURL = baseURL.appendingPathComponent(Endpoints.items.rawValue).appendingPathComponent(String(itemID))
		print(itemURL)

		var request = URLRequest(url: itemURL)
		request.httpMethod = HTTPMethods.delete.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		networkHandler.transferMahCodableDatas(with: request) { [weak self] (result: Result<ListingResponse, NetworkError>) in
			self?.refreshItems()
			completion(result)
		}
	}

	func update(existingItem item: Listing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			// FIXME: perhaps change error here? - reset to login screen
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			return
		}
		guard let itemID = item.id else { return }
		let itemURL = baseURL.appendingPathComponent(Endpoints.items.rawValue).appendingPathComponent(String(itemID))
		print(itemURL)

		var request = URLRequest(url: itemURL)
		request.httpMethod = HTTPMethods.put.rawValue
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		let encoder = JSONEncoder()
		do {
			request.httpBody = try encoder.encode(item)
		} catch {
			completion(.failure(.dataCodingError(specifically: error)))
		}

		networkHandler.transferMahCodableDatas(with: request) { [weak self] (result: Result<ListingResponse, NetworkError>) in
			self?.refreshItems()
			completion(result)
		}
	}

	// MARK: - list derivatives
	var availableItems = [Listing]()
	var categories = [ItemCategory: [Listing]]()
	var topRatedListings = [Listing]()
	var recommendedForYouListings = [Listing]()
	var myListings = [Listing]()
	var myRentals = [Listing]()
//	var myFavorites = [Listing]()

	private func updateDerivatives() {
		updateAvailableItems()
		updateCategories()
		updateRandomList(randomList: &topRatedListings)
		updateRandomList(randomList: &recommendedForYouListings)
		updateMyListings()
		updateMyRentals()
	}

	private func updateAvailableItems() {
		availableItems = itemListings.filter { $0.availability && $0.renter == nil }
	}

	private func updateCategories() {
		categories.removeAll()
		for listing in availableItems {
			let category = ItemCategory.getCategory(for: listing.type)
			categories[category, default: []].append(listing)
		}
	}

	private func updateRandomList( randomList: inout [Listing]) {
		randomList.removeAll()
		var tempListings = availableItems
		let max = min(5, tempListings.count)
		for _ in 0..<max {
			let value = Int.random(in: 0..<tempListings.count)
			randomList.append(tempListings[value])
			tempListings.remove(at: value)
		}
	}

	private func updateMyListings() {
		guard let bearer = bearer else { return }
		myListings = itemListings.filter {
			$0.owner == bearer.id
		}
	}

	private func updateMyRentals() {
		guard let bearer = bearer else { return }
		myRentals = itemListings.filter {
			$0.renter == bearer.id
		}
	}

	// MARK: - my listing management

	func deleteFromMyListings(item: Listing) {
		delete(existingItem: item) { _ in }
		guard let index = myListings.firstIndex(of: item) else { return }
		myListings.remove(at: index)
	}

	func removeFromMyRentals(item: Listing) {
		var item = item
		item.renter = nil
		print(item)
		update(existingItem: item) { (result: Result<ListingResponse, NetworkError>) in
			do {
				_ = try result.get()
			} catch {
				print(error)
			}
		}

		guard let index = myRentals.firstIndex(of: item) else { return }
		myRentals.remove(at: index)
	}

	// MARK: - data persistance
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
