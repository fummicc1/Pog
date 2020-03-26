//
//  FindDiaryMapViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

final class DiaryMapViewModel: BaseViewModel {
	
    typealias Input = _Input
    
    struct _Input {
    }
    
	private var locationManager: CLLocationManager?
	private let model: DiariesModel
	
	private let diariesRelay: BehaviorRelay<[Entity.Diary]> = .init(value: [])	
	var diariesObservable: Observable<[Entity.Diary]> {
		diariesRelay.asObservable()
	}
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(model: DiariesModel = DiariesModelImpl()) {
        self.model = model
    }
    
    func configure(input: DiaryMapViewModel.Input) {
    }
}
