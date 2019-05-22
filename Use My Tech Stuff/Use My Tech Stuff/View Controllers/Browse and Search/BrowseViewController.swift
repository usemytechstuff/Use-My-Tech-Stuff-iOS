//
//  BrowseViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, TechStuffAccessor {

	@IBOutlet var categoriesCollectionView: UICollectionView!
	@IBOutlet var topRatedCollectionView: UICollectionView!
	@IBOutlet var recommendedCollectionView: UICollectionView!
	let categoriesController = CategoriesController()
	let topRatedItemController = RandomItemController()
	let recommendedItemController = RandomItemController()

	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		topRatedItemController.requestData()
		recommendedItemController.requestData()
	}

	private func setupCollectionViews() {
		let browseCellNib = UINib(nibName: "BrowseCollectionViewCell", bundle: nil)

		categoriesCollectionView.register(browseCellNib, forCellWithReuseIdentifier: "Cell")
		categoriesCollectionView.dataSource = categoriesController
		categoriesCollectionView.delegate = categoriesController

		let showListingDetailClosure: (BrowseCollectionViewCell) -> Void = { [weak self] browseCell in
			self?.showListingDetail(withListing: browseCell.listing)
		}

		topRatedItemController.refreshedClosure = { [weak self] in
			DispatchQueue.main.async {
				self?.topRatedCollectionView.reloadData()
			}
		}
		topRatedItemController.itemTouchedClosure = showListingDetailClosure
		topRatedItemController.techStuffController = techStuffController
		topRatedCollectionView.register(browseCellNib, forCellWithReuseIdentifier: "Cell")
		topRatedCollectionView.dataSource = topRatedItemController
		topRatedCollectionView.delegate = topRatedItemController

		recommendedItemController.randomSelection = .recommendedForYou
		recommendedItemController.refreshedClosure = { [weak self] in
			DispatchQueue.main.async {
				self?.recommendedCollectionView.reloadData()
			}
		}
		recommendedItemController.itemTouchedClosure = showListingDetailClosure
		recommendedItemController.techStuffController = techStuffController
		recommendedCollectionView.register(browseCellNib, forCellWithReuseIdentifier: "Cell")
		recommendedCollectionView.dataSource = recommendedItemController
		recommendedCollectionView.delegate = recommendedItemController
	}

	func showListingDetail(withListing listing: Listing?) {
		guard let viewItemVCArray = Bundle.main.loadNibNamed("ListingDetailViewController",
															 owner: nil,
															 options: nil) as? [ListingDetailViewController],
			let viewItemVC = viewItemVCArray.first else { return }
		viewItemVC.techStuffController = techStuffController
		viewItemVC.listing = listing
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.pushViewController(viewItemVC, animated: true)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let techAccess = segue.destination as? TechStuffAccessor {
			techAccess.techStuffController = techStuffController
		}
	}
}

class BrowseNavViewController: UINavigationController, TechStuffAccessor {
	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		super.viewDidLoad()
		viewControllers.forEach {
			if let techStuff = $0 as? TechStuffAccessor {
				techStuff.techStuffController = techStuffController
			}
		}
	}
}
