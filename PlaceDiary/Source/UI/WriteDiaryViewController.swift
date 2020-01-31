//
//  WriteDiaryViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/31.
//

import UIKit

class WriteDiaryViewController: BaseViewController {

	private var placeTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "どんな場所か教えてください"
		return textField
	}()
	
	private var memoryTextView: UITextView = {
		let textView = UITextView()
		return textView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(placeTextField)
		view.addSubview(memoryTextView)
		
		placeTextField.snp.makeConstraints { maker in
			maker.top.equalTo(view).offset(64)
			maker.leading.equalTo(view).offset(40)
			maker.centerX.equalTo(view)
		}
		
		memoryTextView.snp.makeConstraints { maker in
			maker.top.equalTo(placeTextField.snp.bottom).offset(40)
			maker.centerX.equalTo(view)
			maker.height.equalTo(240).priority(.high)
			maker.leading.equalTo(view).offset(40)
		}
    }
}
