//
//  BottomActionBarView.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit

class BottomActionBarViewController: BaseViewController {
	
	@IBOutlet private weak var stackView: UIStackView?
	
	private let viewModel: BottomActionBarViewModel
	
	init(viewModel: BottomActionBarViewModel = BottomActionBarViewModelImpl()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
    @available(iOS 13, *)
    init?(viewModel: BottomActionBarViewModel = BottomActionBarViewModelImpl(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
	required init?(coder: NSCoder) {
        viewModel = BottomActionBarViewModelImpl()
        super.init(coder: coder)
	}
}
