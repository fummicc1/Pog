//
//  HomeViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import CoreLocation

class HomeViewController: BaseViewController {

	private var bottomActionBarViewController: BottomActionBarViewController = {
		let viewModel = BottomActionBarViewModelImpl()
		let viewController = BottomActionBarViewController(viewModel: viewModel)
		return viewController
	}()
	
	private var findDiaryMapViewController: FindDiaryMapViewController = {
		let viewModel = FindDiaryMapViewModelImpl(input: FindDiaryMapViewModelImpl.Input(locationManager: CLLocationManager(), model: FindDiaryMapModelImpl()))
		let viewController = FindDiaryMapViewController(viewModel: viewModel)
		return viewController
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(findDiaryMapViewController.view)
		view.addSubview(bottomActionBarViewController.view)
		
		findDiaryMapViewController.view.snp.makeConstraints { maker in
			maker.top.bottom.leading.trailing.equalTo(self.view)
		}
		
		bottomActionBarViewController.view.snp.makeConstraints { maker in
			maker.bottom.equalTo(self.view).offset(-64)
			maker.height.equalTo(64)
			maker.leading.equalTo(self.view).offset(32)
			maker.trailing.equalTo(self.view).offset(-32)
		}
    }
}
