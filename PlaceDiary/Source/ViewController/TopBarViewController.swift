//
//  TopBarViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit

class TopBarViewController: BaseViewController {

    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 16
        bindViewModel()
        listenViewModel()
    }
    
    override func listenViewModel() {
    }
    
    override func bindViewModel() {
    }
}
