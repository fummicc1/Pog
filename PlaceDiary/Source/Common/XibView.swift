//
//  XibView.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/29.
//

import Foundation
import UIKit

class XibView: UIView {
    
    class var nibName: String {
        return String(describing: self)
    }
    
    @IBOutlet private var _view: UIView! {
        didSet {
            _view.frame = bounds
            addSubview(_view)
            _view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: type(of: self).nibName, bundle: nil)
            .instantiate(withOwner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UINib(nibName: type(of: self).nibName, bundle: nil)
            .instantiate(withOwner: self, options: nil)
    }
}
