//
//  SearchResultTableViewCell.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell, TechStuffAccessor {

	var techStuffController: TechStuffController?

	@IBOutlet var searchResultImageView: UIImageView!
	@IBOutlet var itemTitleLabel: UILabel!
	@IBOutlet var itemBrandModelLabel: UILabel!
	@IBOutlet var itemDescriptionLabel: UILabel!
	@IBOutlet var itemPriceLabel: UILabel!

	var listing: Listing? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		guard let listing = listing, searchResultImageView != nil else { return }
		searchResultImageView.image = UIImage(named: "placeholderImage")
		itemTitleLabel.text = listing.title
		itemDescriptionLabel.text = listing.description
		itemBrandModelLabel.text = StringFormatting.formatBrandAndModel(brand: listing.brand, model: listing.model)

		itemPriceLabel.text = StringFormatting.formatPrice(withIntValue: listing.price)

		guard let imgURL = listing.imgURL else { print("no url: \(listing)"); return }
		techStuffController?.get(imageAtURL: imgURL, completion: { [weak self] (result: Result<UIImage, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let image = try result.get()
					self?.searchResultImageView.image = image
				} catch {
					print("failed getting image: \(error)")
				}
			}
		})
	}
}
