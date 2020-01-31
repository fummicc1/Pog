//
//  FindDiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit
import RxMKMapView
import SnapKit

class FindDiaryMapViewController: BaseViewController {
	
	private var mapView: MKMapView = {
		let mapView = MKMapView()
		mapView.showsBuildings = false
		mapView.showsUserLocation = true
		return mapView
	}()
	
	private let viewModel: FindDiaryMapViewModel
	
	init(viewModel: FindDiaryMapViewModel) {
		self.viewModel = viewModel
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
		setRxMap()
		bindViewModel()
    }
	
	private func setRxMap() {
		mapView.rx.setDelegate(self).disposed(by: disposeBag)
	}
	
	private func bindViewModel() {
		viewModel.diariesObservable.subscribe(onNext: { [unowned self] diaries in
			let annotations = diaries.map { DiaryAnnotation(diary: $0) }
			self.mapView.addAnnotations(annotations)
		}).disposed(by: disposeBag)
	}
}

extension FindDiaryMapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let annotation = annotation as? DiaryAnnotation {
			let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: DiaryAnnotation.className)
			return view
		}
		return nil
	}
}
