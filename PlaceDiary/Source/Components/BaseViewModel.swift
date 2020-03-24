//
//  BaseViewModel.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    var disposeBag: DisposeBag { get }
    
    associatedtype Input
    
    func configure(input: Input)
}
