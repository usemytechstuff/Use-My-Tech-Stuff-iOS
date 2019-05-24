//
//  ListingDetailViewController.swift
//  renTech
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
	var priceValue: Int?
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
	var listing: ItemListing? {
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
		updatePriceInfo()
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

	@IBAction func priceFieldChanged(_ sender: UITextField) {
		updatePriceInfo()
	}

	func updatePriceInfo() {
		guard var priceStr = priceTextField.text else {
			priceValue = 0
			priceTextField.text = "Free"
			return
		}
		let numbers = Set("0123456789")
		priceStr = priceStr.filter { numbers.contains($0) }
		priceValue = Int(priceStr) ?? 0
		priceStr = StringFormatting.formatPrice(withIntValue: priceValue ?? 0)
		if priceValue ?? 0 == 0 {
			priceTextField.text = "Free"
		} else {
			priceTextField.text = priceStr
		}
	}

	@IBAction func submitButtonPressed(_ sender: UIButton) {
		submitItem()
	}

	private func submitItem() {
		guard let bearer = techStuffController?.bearer else { return }
		guard let title = titleTextField.text, !title.isEmpty else {
			titleTextField.wiggle()
			return
		}
		guard let description = descriptionTextView.text, !description.isEmpty else {
			descriptionTextView.wiggle()
			return
		}
		let type = ItemCategory.getCategory(for: categoryPicker.selectedRow(inComponent: 0)).rawValue
		guard let price = priceValue else {
			priceTextField.wiggle()
			return
		}
		let availability = availabilitySwitch.isOn

		var listing: ItemListing
		if let existingListing = self.listing {
			listing = ItemListing(id: existingListing.id,
							  owner: existingListing.owner,
							  type: type,
							  description: description,
							  brand: nil,
							  model: nil,
							  imgURL: nil,
							  price: price,
							  title: title,
							  availability: availability,
							  renter: existingListing.renter)
		} else {
			listing = ItemListing(owner: bearer.id,
							  type: type,
							  description: description,
							  price: price,
							  title: title,
							  availability: availability)
		}
		listing.brand = brandTextField.text
		listing.model = modelTextField.text
		listing.imgURL = imageURLTextField.text

		switch mode {
		case .creatingOwn:
			techStuffController?.post(newItem: listing,
									  completion: { [weak self] (result: Result<ListingResponse, NetworkError>) in
				DispatchQueue.main.async {
					do {
						let response = try result.get()
						print(response.message)

						self?.navigationController?.popViewController(animated: true)
					} catch {
						let alert = UIAlertController(error: error)
						self?.present(alert, animated: true)
					}
				}
			})
		case .updatingOwn:
			techStuffController?.update(existingItem: listing,
										completion: { [weak self] (result: Result<ListingResponse, NetworkError>) in
				DispatchQueue.main.async {
					do {
						let response = try result.get()
						print(response.message)

						self?.navigationController?.popViewController(animated: true)
					} catch {
						let alert = UIAlertController(error: error)
						self?.present(alert, animated: true)
					}
				}
			})
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

	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let string = ItemCategory.allCases[row].rawValue
		let snake = string.uncamelized
		let result = snake.replacingOccurrences(of: "_", with: " ")
		return NSAttributedString(string: result, attributes: [NSAttributedString.Key.foregroundColor: AppearanceHelper.rentechBlack])
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let string = ItemCategory.allCases[row].rawValue
		let snake = string.uncamelized
		let result = snake.replacingOccurrences(of: "_", with: " ")
		return result.capitalized
	}
}
