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
	let categoriesController = CategoriesController()
	let randomItemController = RandomItemController()

	var techStuffController: TechStuffController?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionViews()
	}

	private func setupCollectionViews() {
		let browseCellNib = UINib(nibName: "BrowseCollectionViewCell", bundle: nil)

		categoriesCollectionView.register(browseCellNib, forCellWithReuseIdentifier: "Cell")
		categoriesCollectionView.dataSource = categoriesController
		categoriesCollectionView.delegate = categoriesController

		randomItemController.refreshedClosure = { [weak self] in
		DispatchQueue.main.async {
		self?.topRatedCollectionView.reloadData()
		}
		}
		randomItemController.techStuffController = techStuffController
		topRatedCollectionView.register(browseCellNib, forCellWithReuseIdentifier: "Cell")
		topRatedCollectionView.dataSource = randomItemController
		topRatedCollectionView.delegate = randomItemController
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
		viewControllers.forEach {
			if let techStuff = $0 as? TechStuffAccessor {
				techStuff.techStuffController = techStuffController
			}
		}
	}
}
