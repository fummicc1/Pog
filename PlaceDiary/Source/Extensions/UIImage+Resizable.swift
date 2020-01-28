//
//  UIImage+Resizable.swift
//  ToiletMap
//
//  Created by Fumiya Tanaka on 2019/10/26.
//

import Foundation
import UIKit

extension UIImage {
    func resize(in rect: CGRect, after size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        draw(in: CGRect(origin: rect.origin, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
