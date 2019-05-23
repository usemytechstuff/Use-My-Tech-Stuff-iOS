//
//  GradientView.swift
//  renTech
//
//  Created by Michael Redig on 5/23/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
	@IBInspectable var firstColor: UIColor = UIColor.clear {
		didSet {
			updateView()
		}
	}

	@IBInspectable var secondColor: UIColor = UIColor.clear {
		didSet {
			updateView()
		}
	}

	override class var layerClass: AnyClass {
		get {
			return CAGradientLayer.self
		}
	}

	private func updateView() {
		guard let layer = self.layer as? CAGradientLayer else { return }
		layer.colors = [firstColor, secondColor].map {$0.cgColor}
	}
}
