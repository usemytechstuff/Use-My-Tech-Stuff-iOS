//
//  FavoritesTableViewController.swift
//  renTech
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController, TechStuffAccessor {
	var techStuffController: TechStuffController?
    override func viewDidLoad() {
        super.viewDidLoad()

		let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "SearchResultCell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
}

// MARK: - table view stuff
extension FavoritesTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return techStuffController?.myFavorites.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
		guard let searchCell = cell as? SearchResultTableViewCell else { return cell }

		let item = techStuffController?.myFavorites[indexPath.row]
		searchCell.techStuffController = techStuffController
		searchCell.listing = item
		return searchCell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = techStuffController?.myFavorites[indexPath.row]
		guard let viewItemVC = UIViewController.listingDetailViewController() else { return }
		viewItemVC.techStuffController = techStuffController
		viewItemVC.listing = item
		navigationController?.pushViewController(viewItemVC, animated: true)
	}
}
