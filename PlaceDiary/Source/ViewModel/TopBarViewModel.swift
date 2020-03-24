//
//  TopBarViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class TopBarViewModel: BaseViewModel {
    
    typealias Input = _Input
    
    struct _Input {
        let segmentedControlIndex: Observable<Int>
        let viewControllerNameChangedByTabBar: Observable<String>
    }
    
    private let currentSelectingDiaryViewControllerNameByTopBarRelay: PublishRelay<String> = .init()
    var currentSelectingDiaryViewControllerNameByTopBar: Observable<String> {
        currentSelectingDiaryViewControllerNameByTopBarRelay.asObservable()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func configure(input: TopBarViewModel._Input) {
        input
            .segmentedControlIndex
            .map ({ index -> String in
                if index == 0 {
                    return DiaryListViewController.className
                } else if index == 1 {
                    return DiaryMapViewController.className
                }
                fatalError()
            })
            .bind(to: currentSelectingDiaryViewControllerNameByTopBarRelay)
            .disposed(by: disposeBag)
        
        input
            .viewControllerNameChangedByTabBar
            .bind(to: currentSelectingDiaryViewControllerNameByTopBarRelay)
            .disposed(by: disposeBag)
    }
}
