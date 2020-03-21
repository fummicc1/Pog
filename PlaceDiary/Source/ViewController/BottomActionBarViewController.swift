//
//  BottomActionBarView.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit

class BottomActionBarViewController: BaseViewController {
	
	@IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var myProfileButton: UIButton!
    
    let viewModel: BottomActionBarViewModel
	
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        listenViewModel()
    }
    
    override func listenViewModel() {
    }
    
    override func bindViewModel() {
        viewModel.configure(
            searchButtonTapped: searchButton.rx.tap.asObservable(),
            myProfileButtonTapped: myProfileButton.rx.tap.asObservable()
        )
    }
}
