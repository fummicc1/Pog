//
//  BottomActionBarViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol BottomActionBarViewModel {
    var selectingViewControllerName: Observable<String> { get }
    func configure(
        searchButtonTapped: Observable<Void>,
        myProfileButtonTapped: Observable<Void>
    )
}

final class BottomActionBarViewModelImpl: BaseViewModel, BottomActionBarViewModel {
    
    private let selectingViewControllerNameRelay: BehaviorRelay<String> = .init(value: "")
    var selectingViewControllerName: Observable<String> {
        selectingViewControllerNameRelay.asObservable()
    }
    
    func configure(searchButtonTapped: Observable<Void>, myProfileButtonTapped: Observable<Void>) {
        searchButtonTapped
            .map ({ [weak self] _ in self?.selectingViewControllerNameRelay.value == DiaryMapViewController.className
                ? DiaryListViewController.className
                : DiaryMapViewController.className                
            })
            .bind(to: selectingViewControllerNameRelay)
            .disposed(by: disposeBag)
        
        myProfileButtonTapped
            .map { _ in MyProfileViewController.className }
            .bind(to: selectingViewControllerNameRelay)
            .disposed(by: disposeBag)
    }
}
