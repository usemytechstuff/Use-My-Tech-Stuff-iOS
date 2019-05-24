//
//  StuffAndProfileContainerController.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class StuffAndProfileContainerController: UIViewController, TechStuffAccessor {

	var techStuffController: TechStuffController?

	@IBOutlet var profileContainerView: UIView!
	@IBOutlet var stuffContainerView: UIView!

	override func viewDidLoad() {
        super.viewDidLoad()

		updateShadow(forOffset: 0)
	}

	private func updateShadow(forOffset offset: CGFloat) {

		let opacity: Float = min(Float(offset) * 0.001, 0.22)

		profileContainerView.layer.shadowPath = UIBezierPath(rect: profileContainerView.bounds).cgPath
		profileContainerView.layer.masksToBounds = false
		profileContainerView.layer.shadowColor = UIColor.black.cgColor
		profileContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		profileContainerView.layer.shadowRadius = 4
		profileContainerView.layer.shadowOpacity = opacity
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? TechStuffAccessor {
			dest.techStuffController = techStuffController
			if let stuffTable = dest as? StuffTableViewController {
				stuffTable.scrollChanged = { [weak self] scrollView in
					self?.updateShadow(forOffset: scrollView.contentOffset.y)
				}
			}
		}
	}

	@IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
		techStuffController?.signOut()
	}
}
