//
//  WriteDiaryViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import UIKit
import MapKit

class WriteDiaryChoosePlaceViewController: BaseViewController {
    
    struct Input {
    }
    
    
    
    private var placeSearchTextField: UITextField  = {
        let texxtField = UITextField()
        texxtField.placeholder = "場所を探す"
        texxtField.font = .boldSystemFont(ofSize: 20)
        texxtField.clearButtonMode = .always
        texxtField.borderStyle = .none
        return texxtField
    }()
    
    private var placeMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsBuildings = false
        mapView.showsUserLocation = true
        return mapView
    }()
    
    
    init(input: Input) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(placeMapView)
        view.addSubview(placeSearchTextField)
        
        placeMapView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        placeSearchTextField.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(64)
            maker.leading.equalTo(view).offset(40)
            maker.centerX.equalTo(view)
        }
    }
}

