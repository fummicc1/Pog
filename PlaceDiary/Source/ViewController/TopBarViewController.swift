//
//  TopBarViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit
import RxSwift

class TopBarViewController: UIViewController, BaseViewController {

    typealias Input = _Input
    
    struct _Input {
        let viewControllerNameChangedByTabBar: Observable<String>
    }
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    let viewModel: TopBarViewModel
    var disposeBag: DisposeBag = DisposeBag()
    
    @available(iOS 13, *)
       init?(viewModel: TopBarViewModel = TopBarViewModel(), coder: NSCoder) {
           self.viewModel = viewModel
           super.init(coder: coder)
       }
       
       required init?(coder: NSCoder) {
           viewModel = TopBarViewModel()
           super.init(coder: coder)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 16
    }
    
    func configure(input: TopBarViewController._Input) {
        viewModel.configure(
            input: TopBarViewModel.Input(
                segmentedControlIndex: segmentedControl.rx.selectedSegmentIndex.asObservable(),
                viewControllerNameChangedByTabBar: input.viewControllerNameChangedByTabBar
            )
        )
        
        viewModel
            .currentSelectingDiaryViewControllerNameByTopBar
            .flatMap ({ name -> Observable<Int> in
                if name == DiaryListViewController.className {
                    return .just(0)
                } else if name == DiaryMapViewController.className {
                    return .just(1)
                }
                return .empty()
            })
            .bind(to: segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}
