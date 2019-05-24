//
//  ImageAnimator.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ImageAnimator: UIView {

	@IBOutlet var contentView: UIView!
	@IBOutlet var imageView: UIImageView!
	var images: [UIImage] = [] {
		didSet {
			stopAnimations()
			imageView.image = images.first
			startAnimations()
		}
	}

	var animationDuration: TimeInterval = 0.5
	var animationInterval: TimeInterval = 3
	private var imageIndex = 0
	private var startingOrigin = CGPoint.zero

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSubviews()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}

	private func initSubviews() {
		let nib = UINib(nibName: "ImageAnimator", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)
		contentView.frame = bounds
		addSubview(contentView)
	}

	func startAnimations() {
		imageView.frame.origin = bounds.origin
		imageView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
		imageIndex = 0
		imageView.image = images[imageIndex]

		firstAnimation()
	}

	private func firstAnimation() {
		UIView.animate(withDuration: animationDuration * 0.5, delay: animationInterval, options: [.curveEaseIn], animations: { [weak self] in
			self?.moveLeft()
			}, completion: { [weak self] _ in
				guard let self = self else { return }
				self.moveRightAndIterate()
				UIView.animate(withDuration: self.animationDuration * 0.5, delay: 0, options: [.curveEaseOut], animations: self.moveBackToCenter, completion: { [weak self] _ in
					self?.firstAnimation()
				})
		})
	}

	private func moveLeft() {
		startingOrigin = imageView.frame.origin
		imageView.frame.origin.x -= imageView.bounds.width
	}

	private func moveRightAndIterate() {
		imageView.frame.origin.x = bounds.width
		imageView.image = images[imageIndex]

		imageIndex += 1
		if imageIndex >= images.count {
			imageIndex = 0
		}
	}

	private func moveBackToCenter() {
		imageView.frame.origin = startingOrigin
	}

	func stopAnimations() {
		imageView.layer.removeAllAnimations()
	}
}
