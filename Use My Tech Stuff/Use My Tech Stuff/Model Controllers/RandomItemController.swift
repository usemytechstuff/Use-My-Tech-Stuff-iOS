//
//  RandomItemController
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class RandomItemController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, TechStuffAccessor {

	var techStuffController: TechStuffController? {
		didSet {
			requestData()
		}
	}
	var listedItems: [Listing] = []

	var refreshedClosure: (() -> Void)?

	func requestData() {
		if techStuffController?.itemListings.count == 0 {
			techStuffController?.getAllItems(completion: { [weak self] (result: Result<Bool, NetworkError>) in
				self?.refreshItems()
			})
		} else {
			refreshItems()
		}
	}

	func refreshItems() {
		guard var tempListings = techStuffController?.itemListings else { return }
		let max = min(5, tempListings.count)
		listedItems.removeAll()
		for _ in 0..<max {
			let value = Int.random(in: 0..<tempListings.count)
			listedItems.append(tempListings[value])
			tempListings.remove(at: value)
		}
		refreshedClosure?()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return listedItems.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		guard let browseCell = cell as? BrowseCollectionViewCell else { return cell }
		browseCell.image = UIImage(named: "placeholderImage")
		browseCell.textLabel.text = listedItems[indexPath.item].title

		if let imageURL = listedItems[indexPath.item].imgURL {
			techStuffController?.get(imageAtURL: imageURL, completion: { (result: Result<UIImage, NetworkError>) in
				DispatchQueue.main.async {
					do {
						let image = try result.get()
						browseCell.image = image
					} catch {
						print("error fetching image: \(error)")
					}
				}
			})
		}
		return browseCell
	}
}
