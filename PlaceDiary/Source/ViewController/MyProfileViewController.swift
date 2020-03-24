//
//  MyProfileViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit
import RxSwift

class MyProfileViewController: UIViewController, BaseViewController {

    typealias Input = _Input
    
    struct _Input {
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(input: MyProfileViewController._Input) {
    }
}
