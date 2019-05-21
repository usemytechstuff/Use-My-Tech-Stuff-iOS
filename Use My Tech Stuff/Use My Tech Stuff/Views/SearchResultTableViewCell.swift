//
//  SearchResultTableViewCell.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

	@IBOutlet var searchResultImageView: UIImageView!
	@IBOutlet var itemTitleLabel: UILabel!
	@IBOutlet var itemBrandModelLabel: UILabel!
	@IBOutlet var itemDescriptionLabel: UILabel!
	@IBOutlet var itemPriceLabel: UILabel!

	var techStuffController: TechStuffController?
	var listing: Listing? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		guard let listing = listing else { return }
		itemTitleLabel.text = listing.title
		itemDescriptionLabel.text = listing.description
		itemBrandModelLabel.text = "\(listing.brand) - \(listing.model)"

		let dollars = listing.price / 100
		let cents = listing.price % 100
		itemPriceLabel.text = "$\(dollars).\(cents)"

		techStuffController?.get(imageAtURL: listing.imgURL, completion: { [weak self] (result: Result<UIImage, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let image = try result.get()
					self?.searchResultImageView.image = image
				} catch {
					print("failed getting image: \(error)")
					self?.searchResultImageView.image = UIImage(named: "placeholderImage")
				}
			}
		})
	}
}
