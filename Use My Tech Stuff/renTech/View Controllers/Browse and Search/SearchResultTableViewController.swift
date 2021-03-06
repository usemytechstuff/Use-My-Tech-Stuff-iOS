//
//  SearchResultTableViewController.swift
//  renTech
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController, TechStuffAccessor {
	var techStuffController: TechStuffController?

	var searchResults = [ItemListing]()

	var category: ItemCategory?
	var searchTerms: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "SearchResultCell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		filterForCategory()
		filterForSearchTerms()
		tableView.reloadData()
	}

	private func filterForCategory() {
		guard let category = category else {
			searchResults = techStuffController?.availableItems ?? []
			return
		}
		searchResults = techStuffController?.categories[category] ?? []
		navigationItem.title = "Category: \(category.rawValue.capitalized)"
	}

	private func filterForSearchTerms() {
		guard let searchTerms = searchTerms, !searchTerms.isEmpty else { return }
		navigationItem.title = "Results for: \(searchTerms)"
		let termArray = searchTerms.lowercased().split(separator: " ").map { String($0) }
		for term in termArray {
			searchResults = searchResults.filter {
				$0.title.lowercased().contains(term) ||
				$0.description.lowercased().contains(term) ||
				$0.brand?.lowercased().contains(term) ?? false ||
				$0.model?.lowercased().contains(term) ?? false ||
				$0.type.lowercased().contains(term)
			}
		}
	}
}

// MARK: - tableview stuff
extension SearchResultTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		guard let searchCell = cell as? SearchResultTableViewCell else { return cell }
		searchCell.techStuffController = techStuffController
		searchCell.listing = searchResults[indexPath.row]
		return searchCell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = searchResults[indexPath.row]
		guard let viewItemVC = UIViewController.listingDetailViewController() else { return }
		viewItemVC.techStuffController = techStuffController
		viewItemVC.listing = item
		navigationController?.pushViewController(viewItemVC, animated: true)
	}
}
