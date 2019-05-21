//
//  SearchResultTableViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController, TechStuffAccessor {
	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

// MARK: - tableview stuff
extension SearchResultTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return techStuffController?.itemListings.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		guard let searchCell = cell as? SearchResultTableViewCell else { return cell }
		searchCell.techStuffController = techStuffController
		searchCell.listing = techStuffController?.itemListings[indexPath.row]
		return searchCell
	}
}
