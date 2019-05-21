//
//  BrowseCollectionViewCell.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell {

	@IBOutlet var myContentView: UIView!
	@IBOutlet var imageView: UIImageView!

	@IBOutlet var textLabel: UILabel! {
		didSet {
			textLabel.layer.shadowOpacity = 1
			textLabel.layer.shadowColor = UIColor.black.cgColor
			textLabel.layer.shadowRadius = 30
			textLabel.layer.shadowOffset = CGSize.zero
		}
	}

	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}
}
