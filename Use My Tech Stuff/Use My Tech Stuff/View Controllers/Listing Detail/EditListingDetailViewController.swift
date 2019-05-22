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
	@IBOutlet var priceTextField: UITextField!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var categoryPicker: UIPickerView!
	@IBOutlet var availabilitySwitch: UISwitch!
	@IBOutlet var submitButton: UIButton!

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
		descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
		descriptionTextView.layer.borderWidth = 0.5
		descriptionTextView.layer.cornerRadius = 8

	}

	func updateViews() {
		guard let listing = listing else { return }
		loadViewIfNeeded()
		titleTextField.text = listing.title
		navigationItem.title = listing.title
		imageURLTextField.text = listing.imgURL
		brandTextField.text = listing.brand
		modelTextField.text = listing.model
		descriptionTextView.text = listing.description
		priceTextField.text = StringFormatting.formatPrice(withIntValue: listing.price)
		let categoryIndex = ItemCategory.getIndex(for: ItemCategory(rawValue: listing.type))
		categoryPicker.selectRow(categoryIndex, inComponent: 0, animated: true)
		availabilitySwitch.isOn = listing.availability

		submitButton.setTitle("Update This Item", for: .normal)
	}

	private func updateMode() {
		switch mode {
		case .creatingOwn:
			navigationItem.title = "Post a new item"
			categoryPicker.selectRow(3, inComponent: 0, animated: false)
		case .updatingOwn:
			navigationItem.title = "Update an item"
		}
	}
}

extension EditListingDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return ItemCategory.allCases.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let string = ItemCategory.allCases[row].rawValue
		let snake = string.uncamelized
		let result = snake.replacingOccurrences(of: "_", with: " ")
		return result.capitalized
	}
}
