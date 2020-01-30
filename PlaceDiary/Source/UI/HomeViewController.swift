//
//  HomeViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

	private var bottomActionBarViewController: BottomActionBarViewController = {
		let viewModel = BottomActionBarViewModelImpl()
		let viewController = BottomActionBarViewController(viewModel: viewModel)
		return viewController
	}()
	
	private var findDiaryMapViewController: FindDiaryMapViewController = {
		let viewController = FindDiaryMapViewController(input: FindDiaryMapViewController.Input(locationManager: CLLocationManager()))
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
