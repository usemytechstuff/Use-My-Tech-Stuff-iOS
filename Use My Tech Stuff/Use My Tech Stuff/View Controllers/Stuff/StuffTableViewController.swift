//
//  StuffTableViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//
//swiftlint:disable vertical_parameter_alignment

import UIKit

class StuffTableViewController: UITableViewController, TechStuffAccessor {

	enum StuffSection: Int {
		case myListings
		case myRentals

		static func getSection(for index: Int) -> StuffSection {
			return StuffSection(rawValue: index) ?? .myListings
		}
	}

	var techStuffController: TechStuffController?
	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "SearchResultCell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		techStuffController?.getAllItems(completion: { [weak self] (result: Result<Bool, NetworkError>) in
			DispatchQueue.main.async {
				do {
					_ = try result.get()
					self?.tableView.reloadData()
				} catch {
					let alert = UIAlertController(error: error)
					self?.present(alert, animated: true)
				}
			}
		})
	}

	@IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
		guard let editItemVCArray = Bundle.main.loadNibNamed("EditListingDetailViewController",
															 owner: nil,
															 options: nil) as? [EditListingDetailViewController],
			let editItemVC = editItemVCArray.first else { return }
		editItemVC.techStuffController = techStuffController
		editItemVC.mode = .creatingOwn
		navigationController?.pushViewController(editItemVC, animated: true)
	}
}

// MARK: - tableview stuff
extension StuffTableViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = StuffSection.getSection(for: section)
		switch section {
		case .myListings:
			return techStuffController?.myListings.count ?? 0
		case .myRentals:
			return techStuffController?.myRentals.count ?? 0
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = StuffSection.getSection(for: section)
		switch section {
		case .myListings:
			return "My Listings"
		case .myRentals:
			return "My Rentals"
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		guard let searchCell = cell as? SearchResultTableViewCell else { return cell }
		searchCell.techStuffController = techStuffController

		let section = StuffSection.getSection(for: indexPath.section)
		switch section {
		case .myListings:
			searchCell.listing = techStuffController?.myListings[indexPath.row]
		case .myRentals:
			searchCell.listing = techStuffController?.myRentals[indexPath.row]
		}

		return searchCell
	}

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let section = StuffSection(rawValue: indexPath.section) else { return nil }
		let action: UIContextualAction
		switch section {
		case .myListings:
			action = UIContextualAction(style: .destructive, title: "Remove Listing", handler: { [weak self] (action, view, handler) in
				guard let item = self?.techStuffController?.myListings[indexPath.row] else { return }
				self?.techStuffController?.deleteFromMyListings(item: item)
				self?.tableView.deleteRows(at: [indexPath], with: .automatic)
				handler(true)
			})
			action.backgroundColor = .red
		case .myRentals:
			action = UIContextualAction(style: .destructive, title: "Return Item To Owner", handler: { [weak self] (action, view, handler) in
				guard let item = self?.techStuffController?.myRentals[indexPath.row] else { return }
				self?.techStuffController?.removeFromMyRentals(item: item)
				self?.tableView.deleteRows(at: [indexPath], with: .automatic)
				handler(true)
			})
			action.backgroundColor = .purple
		}
		return UISwipeActionsConfiguration(actions: [action])
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let section = StuffSection(rawValue: indexPath.section) else { return }
		switch section {
		case .myListings:
			let item = techStuffController?.myListings[indexPath.row]
			guard let editItemVCArray = Bundle.main.loadNibNamed("EditListingDetailViewController",
																 owner: nil,
																 options: nil) as? [EditListingDetailViewController],
				let editItemVC = editItemVCArray.first else { return }
			editItemVC.techStuffController = techStuffController
			editItemVC.mode = .updatingOwn
			editItemVC.listing = item
			navigationController?.pushViewController(editItemVC, animated: true)
		case .myRentals:
			let item = techStuffController?.myRentals[indexPath.row]
			guard let viewItemVC = UIViewController.listingDetailViewController() else { return }
			viewItemVC.techStuffController = techStuffController
			viewItemVC.listing = item
			navigationController?.pushViewController(viewItemVC, animated: true)
		}
	}
}
