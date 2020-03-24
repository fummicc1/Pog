//
//  BottomActionBarView.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import RxSwift

class BottomActionBarViewController: UIViewController, BaseViewController {
	
    typealias Input = _Input
    
    struct _Input {
    }
    
	@IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var diariesButton: UIButton!
    @IBOutlet private weak var myProfileButton: UIButton!
    
    let viewModel: BottomActionBarViewModel
    var disposeBag: DisposeBag = DisposeBag()
	
	init(viewModel: BottomActionBarViewModel = BottomActionBarViewModel()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
    @available(iOS 13, *)
    init?(viewModel: BottomActionBarViewModel = BottomActionBarViewModel(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
	required init?(coder: NSCoder) {
        viewModel = BottomActionBarViewModel()
        super.init(coder: coder)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(input: Input) {
        viewModel.configure(
            input: BottomActionBarViewModel.Input(
                searchButtonTapped: diariesButton.rx.tap.asObservable(),
                myProfileButtonTapped: myProfileButton.rx.tap.asObservable()
            )
        )
    }
}
