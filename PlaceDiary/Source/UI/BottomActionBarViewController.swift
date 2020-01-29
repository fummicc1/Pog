//
//  BottomActionBarView.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit

class BottomActionBarViewController: BaseViewController {
	
	private var writeDiaryButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [writeDiaryButton])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
}
