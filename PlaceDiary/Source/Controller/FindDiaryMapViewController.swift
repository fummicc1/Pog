//
//  FindDiaryMapViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import MapKit

class FindDiaryMapViewController: BaseViewController {
	
	@IBOutlet private var mapView: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FindDiaryMapViewController: MKMapViewDelegate {
    
}
