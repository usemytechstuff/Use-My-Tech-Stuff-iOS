//
//  Animations.swift
//  Use My Tech Stuff
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

enum Animations {
	static func wiggle(view: UIView) {
		let spring = { (finished: Bool) in
			UIView.animate(withDuration: 1,
						   delay: 0,
						   usingSpringWithDamping: 0.2,
						   initialSpringVelocity: 0,
						   options: [],
						   animations: {
							view.transform = .identity
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.1, animations: {
			view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
		}, completion: spring)
	}
}
