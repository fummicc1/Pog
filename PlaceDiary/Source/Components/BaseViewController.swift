//
//  BaseViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit

class BaseViewController: UIViewController {
	override func loadView() {
		guard let view = R.nib.bottomActionBarViewController(owner: self) else {
			fatalError()
		}
		self.view = view
	}
}
