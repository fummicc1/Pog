//
//  RadiusImageView.swift
//  ToiletMap
//
//  Created by Fumiya Tanaka on 2020/01/25.
//

import Foundation
import UIKit

class RadiusImageView: UIImageView {
    
	@IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius == 0 ? min(frame.width, frame.height) / 2 : layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
	
    @IBInspectable var borderWidth: CGFloat {
        get {
            self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    init(frame: CGRect, borderWidth: CGFloat, borderColor: UIColor = .systemGray, buttonTitle: String?, buttonImage: UIImage?) {
        super.init(frame: frame)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
		layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.borderColor = UIColor.systemGray.cgColor
		layer.masksToBounds = true
    }
    
}

