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

protocol FindDiaryMapViewModel {
	var diariesObservable: Observable<[Entity.Diary]> { get }
}

final class FindDiaryMapViewModelImpl: BaseViewModel, FindDiaryMapViewModel {
	
	struct Input {
		let locationManager: CLLocationManager
		let model: FindDiaryMapModel
	}
	
	private let locationManager: CLLocationManager
	private let model: FindDiaryMapModel
	
	private let diariesRelay: BehaviorRelay<[Entity.Diary]> = .init(value: [])
	
	var diariesObservable: Observable<[Entity.Diary]> {
		diariesRelay.asObservable()
	}
	
	init(input: Input) {
		self.model = input.model
		self.locationManager = input.locationManager
		super.init()
		
		input.locationManager.rx.status.subscribe (onNext:{ (status) in
			switch status {
			case .authorizedAlways, .authorizedWhenInUse:
				input.locationManager.startUpdatingLocation()
			case .notDetermined:
				input.locationManager.requestWhenInUseAuthorization()
			default:
				break
			}
		}).disposed(by: disposeBag)
		
		input.model.listenDiaries()
			.catchErrorJustReturn([])
			.asObservable()
			.bind(to: diariesRelay)
			.disposed(by: disposeBag)
	}
}
