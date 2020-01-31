//
//  FindDiaryMapViewModelTests.swift
//  PlaceDiaryTests
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import CoreLocation
@testable import PlaceDiary

class FindDiaryMapViewModelTests: XCTestCase {

	private var viewModel: FindDiaryMapViewModel?
	
    override func setUp() {		
		let input: FindDiaryMapViewModelImpl.Input = .init(locationManager: CLLocationManager(), model: FindDiaryMapModelImpl())
		let viewModel = FindDiaryMapViewModelImpl(input: input)
		self.viewModel = viewModel
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
