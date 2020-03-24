//
//  BottomActionBarViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class BottomActionBarViewModel: BaseViewModel {
    
    typealias Input = _Input
    
    struct _Input {
        let searchButtonTapped: Observable<Void>
        let myProfileButtonTapped: Observable<Void>
    }
    
    private let selectingViewControllerNameRelay: BehaviorRelay<String> = .init(value: "")
    var selectingViewControllerName: Observable<String> {
        selectingViewControllerNameRelay.asObservable()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func configure(input: Input) {
        input.searchButtonTapped
            .map ({ [weak self] _ in self?.selectingViewControllerNameRelay.value == DiaryMapViewController.className
                ? DiaryListViewController.className
                : DiaryMapViewController.className                
            })
            .bind(to: selectingViewControllerNameRelay)
            .disposed(by: disposeBag)
        
        input.myProfileButtonTapped
            .map { _ in MyProfileViewController.className }
            .bind(to: selectingViewControllerNameRelay)
            .disposed(by: disposeBag)
    }
}
