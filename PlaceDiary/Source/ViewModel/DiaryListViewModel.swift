//
//  DiaryListViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

class DiaryListViewModel: BaseViewModel {
    
    struct DiarySection: SectionModelType {
        typealias Item = Entity.Diary
        
        var items: [Item]
        
        init(original: DiaryListViewModel.DiarySection, items: [Entity.Diary]) {
            self = original
            self.items = items
        }
        
        init(items: [Entity.Diary]) {
            self.items = items
        }
    }
    
    typealias Input = _Input
    
    struct _Input {
        
    }
    
    var diaries: Observable<DiarySection> {
        diariesRelay.map { DiarySection(items: $0) }
    }
    private let diariesRelay: BehaviorRelay<[Entity.Diary]> = .init(value: [])
    
    var disposeBag: DisposeBag = DisposeBag()
    private let model: DiariesModel
    
    init(model: DiariesModel = DiariesModelImpl()) {
        self.model = model
    }
    
    func configure(input: DiaryListViewModel._Input) {
        model
            .listenDiaries()
            .asObservable()
            .bind(to: diariesRelay)
            .disposed(by: disposeBag)
    }
}
