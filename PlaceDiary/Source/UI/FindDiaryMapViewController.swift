//
//  FindDiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit
import SnapKit

class FindDiaryMapViewController: BaseViewController {
	
	struct Input {
		let locationManager: LocationManager
	}
	
	private var mapView: MKMapView = {
		let mapView = MKMapView()		
		return mapView
	}()
	
	private let viewModel: FindDiaryMapViewModel
	
	init(input: Input) {
		viewModel = FindDiaryMapViewModelImpl(input: FindDiaryMapViewModelImpl.Input(locationManager: input.locationManager))
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(mapView)
		mapView.snp.makeConstraints { maker in
			maker.top.leading.trailing.bottom.equalTo(self.view)
		}
    }
}

extension FindDiaryMapViewController: MKMapViewDelegate {
    
}
