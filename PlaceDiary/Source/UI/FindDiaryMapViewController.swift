//
//  FindDiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit

class FindDiaryMapViewController: BaseViewController {
	
	struct Input {
	}
	
	private var mapView: MKMapView = {
		let mapView = MKMapView()
		mapView.translatesAutoresizingMaskIntoConstraints = false
		return mapView
	}()
	
	private let viewModel: FindDiaryMapViewModel
	
	init(input: Input) {
		viewModel = FindDiaryMapViewModelImpl(input: input)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(mapView)
    }
}

extension FindDiaryMapViewController: MKMapViewDelegate {
    
}
