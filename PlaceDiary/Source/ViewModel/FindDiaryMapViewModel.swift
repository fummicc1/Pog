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


protocol FindDiaryMapViewModel {
}

class FindDiaryMapViewModelImpl: BaseViewModel, FindDiaryMapViewModel {
	
	struct Input {
		let locationManager: LocationManager
	}
	
	private var locationManager: LocationManager
	
	init(input: Input) {
		self.locationManager = input.locationManager
		super.init()
		self.locationManager.delegate = self
	}
}

extension FindDiaryMapViewModelImpl: CLLocationManagerDelegate {
	
}
