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
}

final class FindDiaryMapViewModelImpl: BaseViewModel, FindDiaryMapViewModel {
	
	struct Input {
		let locationManager: CLLocationManager
	}
	
	private var locationManager: CLLocationManager
	
	init(input: Input) {
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
	}
}
