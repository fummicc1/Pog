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

protocol DiaryMapViewModel {
	var diariesObservable: Observable<[Entity.Diary]> { get }
}

final class DiaryMapViewModelImpl: BaseViewModel, DiaryMapViewModel {
	
	private var locationManager: CLLocationManager?
	private let model: DiaryMapModel
	
	private let diariesRelay: BehaviorRelay<[Entity.Diary]> = .init(value: [])	
	var diariesObservable: Observable<[Entity.Diary]> {
		diariesRelay.asObservable()
	}
    
    init(model: DiaryMapModel = DiaryMapModelImpl()) {
        self.model = model
    }
}
