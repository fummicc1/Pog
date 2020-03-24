//
//  DiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit
import RxMKMapView
import RxSwift
import SnapKit

class DiaryMapViewController: UIViewController, BaseViewController {
	
    typealias Input = _Input
    
    struct _Input {
    }
    
	@IBOutlet private weak var mapView: MKMapView!
	
	let viewModel: DiaryMapViewModel
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @available(iOS 13, *)
    init?(viewModel: DiaryMapViewModel = DiaryMapViewModel(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        viewModel = DiaryMapViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func configure(input: DiaryMapViewController._Input) {
        viewModel.configure(
            input: DiaryMapViewModel.Input()
        )
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
