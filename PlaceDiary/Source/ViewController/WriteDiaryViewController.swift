//
//  WriteDiaryViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/26.
//

import UIKit
import RxSwift
import RxCocoa
import YPImagePicker

class WriteDiaryViewController: UIViewController, BaseViewController {
    
    typealias Input = _Input
    
    struct _Input {
        let viewModelInput: WriteDiaryViewModel.Input
    }
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var memoryTextView: UITextView!
    @IBOutlet private weak var postButton: UIBarButtonItem!
    @IBOutlet private weak var photoImageButton: UIButton!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var dismissButton: UIBarButtonItem!
    
    var disposeBag: DisposeBag = DisposeBag()
    let viewModel: WriteDiaryViewModel
    
    @available(iOS 13, *)
    init?(viewModel: WriteDiaryViewModel = WriteDiaryViewModel(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        viewModel = WriteDiaryViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        photoImageButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in                
                let imagePicker = YPImagePicker()
            })
            .disposed(by: disposeBag)
        
        configure(input: Input(
            viewModelInput: WriteDiaryViewModel.Input(
                memoryObservable: memoryTextView.rx.text.orEmpty.asObservable(),
                placeObservable: placeTextField.rx.text.orEmpty.asObservable()
            )
        ))
    }
    
    func configure(input: _Input) {
        viewModel.configure(input: input.viewModelInput)
    }
}
