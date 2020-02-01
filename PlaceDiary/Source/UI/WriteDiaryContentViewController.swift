//
//  WriteDiaryContentViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/02/01.
//

import UIKit

class WriteDiaryContentViewController: BaseViewController {

    private var tagTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "タグを決めると作成後、検索時に調べやすくなります！"
        textField.font = .boldSystemFont(ofSize: 12)
        return textField
    }()
    
    private var memoryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.label.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private var emptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "自由に思い出を残しましょう"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var selectHeadingImageButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 40))
        button.setImage(UIImage.init(systemName: "camera", withConfiguration: config), for: .normal)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 48
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tagTextField)
        view.addSubview(selectHeadingImageButton)
        view.addSubview(memoryTextView)
        view.addSubview(emptyTextLabel)
        
        tagTextField.snp.makeConstraints { maker in
            maker.top.equalTo(view).offset(40)
            maker.centerX.equalTo(view)
        }
        
        selectHeadingImageButton.snp.makeConstraints { maker in
            maker.top.equalTo(tagTextField.snp.bottom).offset(40)
            maker.centerX.equalTo(view)
            maker.size.equalTo(96)
        }
        
        memoryTextView.snp.makeConstraints { maker in
            maker.top.equalTo(selectHeadingImageButton.snp.bottom).offset(40)
            maker.centerX.equalTo(view)
            maker.height.equalTo(160)
            maker.leading.equalTo(view).offset(40)
        }
        
        emptyTextLabel.snp.makeConstraints { maker in
            maker.top.equalTo(memoryTextView).offset(8)
            maker.leading.equalTo(memoryTextView).offset(8)
            maker.trailing.equalTo(memoryTextView)
        }
        
        memoryTextView.rx.text.orEmpty.asObservable().subscribe(onNext: { [unowned self] text in
            self.emptyTextLabel.isHidden = text.isEmpty.reverse()
        }).disposed(by: disposeBag)
        
        selectHeadingImageButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}


extension WriteDiaryContentViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectHeadingImageButton.setImage(image, for: .normal)
        }
        if let imageURL = info[.imageURL] as? URL {
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

