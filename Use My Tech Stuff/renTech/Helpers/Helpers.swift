//
//  Helpers.swift
//  renTech
//
//  Created by Michael Redig on 5/22/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

extension UIViewController {
	static func listingDetailViewController() -> ListingDetailViewController? {
		guard let viewItemVCArray = Bundle.main.loadNibNamed("ListingDetailViewController",
															 owner: nil,
															 options: nil) as? [ListingDetailViewController],
			let viewItemVC = viewItemVCArray.first else { return nil }
		return viewItemVC
	}

	static func editListingDetailViewController() -> EditListingDetailViewController? {
		guard let editItemVCArray = Bundle.main.loadNibNamed("EditListingDetailViewController",
															 owner: nil,
															 options: nil) as? [EditListingDetailViewController],
			let editItemVC = editItemVCArray.first else { return nil }
		return editItemVC
	}
}

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

extension NSNotification.Name {
	static let checkLoginNotificationName = NSNotification.Name(rawValue: "com.redeggproductions.renTech.checkLogin")
}

enum AppearanceHelper {

	static let rentechBlack = UIColor(named: "rentechBlack")
	static let rentechIndigo = UIColor(named: "rentechIndigo")
	static let rentechWhite = UIColor(named: "rentechWhite")

	static func setupAppearance() {
		guard let rentechBlack = rentechBlack else { return }
		let textAttributes = [
			NSAttributedString.Key.foregroundColor: rentechBlack,
			NSAttributedString.Key.font: headerFont(with: .headline, pointSize: 26)
		]
		UINavigationBar.appearance().titleTextAttributes = textAttributes
		UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
	}

	static func headerFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
		let font = UIFont(name: "Nunito-Bold", size: pointSize)!
		return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
	}

	static func standardFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
		let font = UIFont(name: "Nunito", size: pointSize)!
		return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
	}
}
