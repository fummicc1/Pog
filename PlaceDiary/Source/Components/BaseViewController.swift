//
//  BaseViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import RxSwift

protocol ViewModelConfigure {
    func listenViewModel()
    func bindViewModel()
}

class BaseViewController: UIViewController, ViewModelConfigure {
	let disposeBag = DisposeBag()
    
    func listenViewModel() {
        fatalError()
    }
    
    func bindViewModel() {
        fatalError()
    }
}
