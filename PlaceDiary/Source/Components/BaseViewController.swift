//
//  BaseViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import UIKit
import RxSwift

protocol BaseViewController {
    
    associatedtype Input
    
    var disposeBag: DisposeBag { get }
    func configure(input: Input)
}
