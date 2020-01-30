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
		let config = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 32))
		button.setImage(UIImage.init(systemName: "pencil.and.outline", withConfiguration: config), for: .normal)
		return button
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [writeDiaryButton])
		return stackView
	}()
	
	private let viewModel: BottomActionBarViewModel
	
	init(viewModel: BottomActionBarViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(stackView)
		
		stackView.snp.makeConstraints { maker in
			maker.top.bottom.leading.trailing.equalTo(self.view)
		}
	}
	
}
