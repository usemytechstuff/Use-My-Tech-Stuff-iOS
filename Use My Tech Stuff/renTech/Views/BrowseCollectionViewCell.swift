//
//  BrowseCollectionViewCell.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell, TechStuffAccessor {

	var techStuffController: TechStuffController?

	@IBOutlet var myContentView: UIView!
	@IBOutlet var imageView: UIImageView!

	var listing: Listing? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet var textLabel: UILabel! {
		didSet {
			textLabel.layer.shadowOpacity = 1
			textLabel.layer.shadowColor = UIColor.black.cgColor
			textLabel.layer.shadowRadius = 30
			textLabel.layer.shadowOffset = CGSize.zero
		}
	}

	func updateViews() {
		guard let listing = listing else { return }
		textLabel.text = listing.title
		imageView.image = UIImage(named: "placeholderImage")

		guard let imageURL = listing.imgURL else { return }
		techStuffController?.get(imageAtURL: imageURL, completion: { [weak self] (result: Result<UIImage, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let image = try result.get()
					self?.imageView.image = image
				} catch {
					print("error retrieving image: \(error)")
				}
			}
		})
	}

	var image: UIImage? {
		didSet {
			imageView.image = image
			listing = nil
		}
	}
}
