//
//  BaseViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit

class BaseViewController: UIViewController {
	override func loadView() {
		guard let view = UINib(nibName: Self.className, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
			fatalError()
		}
		self.view = view
	}
}
