//
//  ListingDetailViewController.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class EditListingDetailViewController: UIViewController, TechStuffAccessor {

	enum ListingMode {
		case updatingOwn
		case creatingOwn
	}

	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var imageURLTextField: UITextField!
	@IBOutlet var brandTextField: UITextField!
	@IBOutlet var modelTextField: UITextField!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var submitButton: UIButton!
	@IBOutlet var priceTextField: UITextField!

	var mode = ListingMode.creatingOwn {
		didSet {
			updateMode()
		}
	}

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
		descriptionTextView.text = listing.description

		updateMode()
	}

	private func updateMode() {
		switch mode {
		case .creatingOwn:
			break
		case .updatingOwn:
			break
		}
	}
}
