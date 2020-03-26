//
//  ShadowButton.swift
//  ToiletMap
//
//  Created by Fumiya Tanaka on 2019/10/26.
//

import UIKit

protocol Shadow {    
    func addShadowAndRadius(
        cornerRadius: CGFloat?,
        shadowColor: CGColor,
        shadowOffset: CGSize,
        shadowRadius: CGFloat?,
        shadowOpacity: Float
    )
    
    func addShadow(
        shadowColor: CGColor,
        shadowOffset: CGSize,
        shadowRadius: CGFloat?,
        shadowOpacity: Float
    )
}

extension Shadow where Self: UIView {
    func addShadowAndRadius(
        cornerRadius: CGFloat? = nil,
        shadowColor: CGColor = UIColor.systemGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 1, height: 8),
        shadowRadius: CGFloat? = nil,
        shadowOpacity: Float = 0.3
    ) {
        layer.cornerRadius = cornerRadius ?? min(frame.width, frame.height) / 2
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius ?? min(frame.width, frame.height) / 2
        layer.shadowOpacity = shadowOpacity
    }
    
    func addShadow(
        shadowColor: CGColor = UIColor.systemGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 1, height: 8),
        shadowRadius: CGFloat? = nil,
        shadowOpacity: Float = 0.3
    ) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius ?? min(frame.width, frame.height) / 2
        layer.shadowOpacity = shadowOpacity
    }
}



extension Shadow where Self: CALayer {
    func addShadowAndRadius(
        cornerRadius: CGFloat? = nil,
        shadowColor: CGColor = UIColor.systemGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 1, height: 8),
        shadowRadius: CGFloat? = nil,
        shadowOpacity: Float = 0.3
    ) {
        self.cornerRadius = cornerRadius ?? min(frame.width, frame.height) / 2
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius ?? min(frame.width, frame.height) / 2
        self.shadowOpacity = shadowOpacity
    }
    
    func addShadow(
        shadowColor: CGColor = UIColor.systemGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 1, height: 8),
        shadowRadius: CGFloat? = nil,
        shadowOpacity: Float = 0.3
    ) {
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius ?? min(frame.width, frame.height) / 2
        self.shadowOpacity = shadowOpacity
    }
}
