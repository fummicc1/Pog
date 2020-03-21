//
//  DiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit
import RxMKMapView
import SnapKit

class DiaryMapViewController: BaseViewController {
	
	@IBOutlet private weak var mapView: MKMapView!
	
	private let viewModel: DiaryMapViewModel
    
    @available(iOS 13, *)
    init?(viewModel: DiaryMapViewModel = DiaryMapViewModelImpl(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        viewModel = DiaryMapViewModelImpl()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setRxMap()
		bindViewModel()
        listenViewModel()
    }
    
	private func setRxMap() {
		mapView.rx.setDelegate(self).disposed(by: disposeBag)
	}
	
    override func listenViewModel() {
    }
    
    override func bindViewModel() {
		viewModel.diariesObservable.subscribe(onNext: { [unowned self] diaries in
			let annotations = diaries.map { DiaryAnnotation(diary: $0) }
			self.mapView.addAnnotations(annotations)
		}).disposed(by: disposeBag)
	}
}

extension DiaryMapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let annotation = annotation as? DiaryAnnotation {
			let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: DiaryAnnotation.className)
			return view
		}
		return nil
	}
}
