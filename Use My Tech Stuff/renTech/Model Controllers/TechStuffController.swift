//
//  TechStuffController.swift
//  renTech
//
//  Created by Michael Redig on 5/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//
//swiftlint:disable type_body_length

import UIKit

protocol TechStuffAccessor: AnyObject {
	var techStuffController: TechStuffController? { get set }
}

class TechStuffController {
	let networkHandler = NetworkHandler()

	var bearer: Bearer? {
		didSet {
			refreshItems()
			loadFavs()
		}
	}

	var itemListings: [ItemListing] = [] {
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
			completion?(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)
			return
		}
		let itemsURL = baseURL.appendingPathComponent(Endpoints.items.rawValue)

		var request = URLRequest(url: itemsURL)
		request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		networkHandler.transferMahCodableDatas(with: request) { (result: Result<[ItemListing], NetworkError>) in
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

	func post(newItem item: ItemListing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)
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

	func delete(existingItem item: ItemListing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)
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

	func update(existingItem item: ItemListing, completion: @escaping (Result<ListingResponse, NetworkError>) -> Void) {
		guard let bearer = bearer else {
			completion(.failure(.httpNon200StatusCode(code: 401, data: nil)))
			NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)
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

	func signOut() {
		guard let bearer = bearer else {
			NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)
			return
		}
		let logoutURL = baseURL.appendingPathComponent(Endpoints.logout.rawValue)

		var request = URLRequest(url: logoutURL)
		request.addValue(bearer.token, forHTTPHeaderField: HTTPHeaderKeys.auth.rawValue)

		networkHandler.transferMahDatas(with: request) { _ in }
		self.bearer = nil
		myFavoritesIDs.removeAll()
		itemListings.removeAll()
		updateDerivatives()
		saveData()
		NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil)

	}

	// MARK: - list derivatives
	var availableItems = [ItemListing]()
	var categories = [ItemCategory: [ItemListing]]()
	var topRatedListings = [ItemListing]()
	var recommendedForYouListings = [ItemListing]()
	var myListings = [ItemListing]()
	var myRentals = [ItemListing]()
	var myFavorites = [ItemListing]()

	private func updateDerivatives() {
		updateAvailableItems()
		updateCategories()
		updateRandomList(randomList: &topRatedListings)
		updateRandomList(randomList: &recommendedForYouListings)
		updateMyListings()
		updateMyRentals()
		updateMyFavorites()
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

	private func updateRandomList( randomList: inout [ItemListing]) {
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

	private func updateMyFavorites() {
		myFavorites = itemListings.filter {
			guard let id = $0.id else { return false }
			return myFavoritesIDs.contains(id)
		}
	}

	// MARK: - my listing management

	func deleteFromMyListings(item: ItemListing) {
		delete(existingItem: item) { _ in }
		guard let index = myListings.firstIndex(of: item) else { return }
		myListings.remove(at: index)
	}

	func removeFromMyRentals(item: ItemListing) {
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

	// MARK: - my favorites management

	private var myFavoritesIDs = Set<Int>()
	func addToFavorites(item: ItemListing?) {
		guard let id = item?.id else { return }
		myFavoritesIDs.insert(id)
		updateMyFavorites()
		saveData()
	}

	func removeFromFavorites(item: ItemListing?) {
		guard let id = item?.id else { return }
		myFavoritesIDs.remove(id)
		updateMyFavorites()
		saveData()
	}

	func itemIsInFavorites(item: ItemListing?) -> Bool {
		guard let id = item?.id else { return false }
		return myFavoritesIDs.contains(id)
	}

	// MARK: - data persistance
	private func saveData() {
		let defaults = UserDefaults.standard
		let encoder = PropertyListEncoder()
		let data = try? encoder.encode(bearer)
		defaults.set(data, forKey: "user")

		// save favorites separately
		saveFavs()
	}

	private func saveFavs() {
		let defaults = UserDefaults.standard
		let encoder = PropertyListEncoder()
		let favData = try? encoder.encode(myFavoritesIDs)
		guard let bearer = bearer else { return }
		defaults.set(favData, forKey: "user-favs-\(bearer.id)")
	}

	private func loadData() {
		let defaults = UserDefaults.standard
		let decoder = PropertyListDecoder()
		guard let data = defaults.data(forKey: "user") else { return }
		let decodedBearer = try? decoder.decode(Bearer.self, from: data)
		self.bearer = decodedBearer

		loadFavs()
	}

	private func loadFavs() {
		let defaults = UserDefaults.standard
		guard let bearer = bearer, let favData = defaults.data(forKey: "user-favs-\(bearer.id)") else { return }
		let decoder = PropertyListDecoder()
		myFavoritesIDs = (try? decoder.decode(Set<Int>.self, from: favData)) ?? Set<Int>()
	}
}
