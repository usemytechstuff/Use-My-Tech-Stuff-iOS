//
//  Animations.swift
//  renTech
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

extension UIView {
	func wiggle() {
		let spring = { (finished: Bool) in
			UIView.animate(withDuration: 1,
						   delay: 0,
						   usingSpringWithDamping: 0.2,
						   initialSpringVelocity: 0,
						   options: [],
						   animations: {
							self.transform = .identity
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.1, animations: {
			self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
		}, completion: spring)
	}
}
