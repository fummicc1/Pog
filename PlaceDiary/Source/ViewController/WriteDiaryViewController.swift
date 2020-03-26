//
//  WriteDiaryViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/26.
//

import UIKit
import RxSwift
import RxCocoa

class WriteDiaryViewController: UIViewController, BaseViewController {
    
    typealias Input = _Input
    
    struct _Input {
        
    }
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var memoryTextView: UITextView!
    @IBOutlet private weak var postButton: UIBarButtonItem!
    @IBOutlet private weak var photoImageButton: UIButton!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var dismissButton: UIBarButtonItem!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func configure(input: _Input) {
        
    }
}
