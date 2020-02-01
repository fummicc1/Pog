//
//  WriteDiaryViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

protocol WriteDiaryChoosePlaceViewModel {
    var findPlaces: Driver<[MKPlacemark]> { get }
}

final class WriteDiaryChoosePlaceViewModelImpl: BaseViewModel, WriteDiaryChoosePlaceViewModel {
    
    struct Input {
        let model: WriteDiaryChoosePlaceModel = WriteDiaryChoosePlaceModelImpl()
        let tagTextObservable: Observable<String>        
    }
    
    private let model: WriteDiaryChoosePlaceModel
    private let findPlacesRelay: BehaviorRelay<[MKPlacemark]> = .init(value: [])
    var findPlaces: Driver<[MKPlacemark]> {
        findPlacesRelay.asDriver()
    }
    
    init(input: Input) {
        self.model = input.model
        super.init()
        input.tagTextObservable
    }
}
