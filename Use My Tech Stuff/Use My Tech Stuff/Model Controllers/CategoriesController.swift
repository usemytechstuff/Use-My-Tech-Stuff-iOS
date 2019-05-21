//
//  CategoriesController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class CategoriesController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

	let categories: [String]

	override init() {
		let temp = "cameras drones headphones projectors screens speakers virtualReality"
		categories = temp.split(separator: " ").map { String($0) }
		super.init()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		guard let browseCell = cell as? BrowseCollectionViewCell else { return cell }
		let image = UIImage(named: categories[indexPath.item])
		browseCell.image = image
		browseCell.textLabel.text = categories[indexPath.item].capitalizedFirst
		return browseCell
	}
}
