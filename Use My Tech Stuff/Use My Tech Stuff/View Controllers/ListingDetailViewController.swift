//
//  ListingDetailViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ListingDetailViewController: UIViewController, TechStuffAccessor {

	enum ListingMode {
		case viewing
		case updatingOwn
		case creatingOwn
	}

	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var brandModelLabel: UILabel!
	@IBOutlet var ownerLabel: UILabel!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var submitButton: UIButton!
	@IBOutlet var priceLabel: UILabel!

	var techStuffController: TechStuffController?
	var listing: Listing? {
		didSet {
			updateViews()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func updateViews() {
		guard let listing = listing else { return }
		loadViewIfNeeded()
		titleTextField.text = listing.title
		navigationItem.title = listing.title
		brandModelLabel.text = "\(listing.brand) - \(listing.model)"
		descriptionTextView.text = listing.description

		let dollars = listing.price / 100
		let cents = listing.price % 100
		priceLabel.text = "$\(dollars).\(cents)"

		//image and owner
		imageView.image = UIImage(named: "placeholderImage")
		guard let imageURL = listing.imgURL else { return }
		techStuffController?.get(imageAtURL: imageURL, completion: { [weak self] (result: Result<UIImage, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let image = try result.get()
					self?.imageView.image = image
				} catch {
					print("error getting image: \(error)")
				}
			}
		})
	}
}
