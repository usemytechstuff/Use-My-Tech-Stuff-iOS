//
//  ListingDetailViewController.swift
//  renTech
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//
//swiftlint:disable line_length

import UIKit

class ListingDetailViewController: UIViewController, TechStuffAccessor {

	enum ListingMode {
		case viewing
		case viewingSelfRented
		case viewingRented
		case viewingOwn
	}

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var brandModelLabel: UILabel!
	@IBOutlet var ownerLabel: UILabel!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var submitButton: UIButton!
	@IBOutlet var priceLabel: UILabel!

	var mode = ListingMode.viewing {
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
		guard let bearer = techStuffController?.bearer else { return }
		loadViewIfNeeded()
		checkMode(item: listing, bearer: bearer)
		navigationItem.title = listing.title
		brandModelLabel.text = StringFormatting.formatBrandAndModel(brand: listing.brand, model: listing.model)
		if brandModelLabel.text == "" {
			brandModelLabel.isHidden = true
		}
		descriptionTextView.text = listing.description

		priceLabel.text = StringFormatting.formatPrice(withIntValue: listing.price)

		updateMode()

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

	private func checkMode(item: Listing, bearer: Bearer) {
		if item.owner == bearer.id {
			mode = .viewingOwn
			return
		}
		if item.renter == bearer.id {
			mode = .viewingSelfRented
			return
		}
		if item.renter != nil && item.renter != bearer.id {
			mode = .viewingRented
			return
		}
		if item.renter == nil {
			mode = .viewing
			return
		}
	}

	private func updateMode() {
		ownerLabel.isHidden = true
		descriptionTextView.isEditable = false
		switch mode {
		case .viewingRented:
			submitButton.setTitle("This item is currently rented", for: .normal)
			submitButton.isEnabled = false
		case .viewingOwn:
			submitButton.setTitle("You own this item!", for: .normal)
			submitButton.isEnabled = false
		case .viewingSelfRented:
			submitButton.setTitle("You're already renting this item!", for: .normal)
			submitButton.isEnabled = false
		case .viewing:
			submitButton.setTitle("Rent This Item", for: .normal)
		}
	}

	@IBAction func submitButtonPressed(_ sender: UIButton) {
		guard var listing = listing else { return }
		listing.renter = techStuffController?.bearer?.id
		sender.isEnabled = false

		techStuffController?.update(existingItem: listing,
									completion: { [weak self] (result: Result<ListingResponse, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let response = try result.get()
					print(response.message)
					let alert = UIAlertController(title: "Rented!", message: "You've successfully rented '\(listing.title)'.\n\nYou will be charged via a **MaGiCaL** payment method!\n\nThe item will appear behind you in 10 seconds. If it doesn't you'll need to take that up with the jerk who posted an item and didn't ship it via magical teleportation to you. Jerks.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Woohoo!",
												  style: .default,
												  handler: { [weak self] _ in
						self?.navigationController?.popViewController(animated: true)
					}))
					self?.present(alert, animated: true)
				} catch {
					let alert = UIAlertController(error: error)
					self?.present(alert, animated: true)
				}
				sender.isEnabled = true
			}
		})
	}
}
