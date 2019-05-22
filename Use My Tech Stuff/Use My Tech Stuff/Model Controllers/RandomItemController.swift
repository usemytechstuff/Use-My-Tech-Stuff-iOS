//
//  RandomItemController
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class RandomItemController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, TechStuffAccessor {

	enum RandomSelection {
		case topRated
		case recommendedForYou
	}

	var randomSelection = RandomSelection.topRated

	var techStuffController: TechStuffController? {
		didSet {
			requestData()
		}
	}

	var refreshedClosure: (() -> Void)?
	var itemTouchedClosure: ((BrowseCollectionViewCell) -> Void)?

	func requestData() {
		if techStuffController?.itemListings.count == 0 {
			techStuffController?.getAllItems(completion: { [weak self] _ in
				self?.refreshItems()
			})
		} else {
			refreshItems()
		}
	}

	func refreshItems() {
		refreshedClosure?()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch randomSelection {
		case .recommendedForYou:
			return techStuffController?.recommendedForYouListings.count ?? 0
		case .topRated:
			return techStuffController?.topRatedListings.count ?? 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		guard let browseCell = cell as? BrowseCollectionViewCell else { return cell }
		browseCell.techStuffController = techStuffController
		let listingArray: [Listing]?
		switch randomSelection {
		case .recommendedForYou:
			listingArray = techStuffController?.recommendedForYouListings
		case .topRated:
			listingArray = techStuffController?.topRatedListings
		}
		browseCell.listing = listingArray?[indexPath.item]

		return browseCell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? BrowseCollectionViewCell else { return }
		itemTouchedClosure?(cell)
	}
}
