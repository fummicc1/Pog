//
//  Color+Ex.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/17.
//

import Foundation
import SwiftUI

extension Color {
    init?(hexStr: String, alpha: Double = 1) {
        var hexStr = hexStr
        if hexStr.hasPrefix("0x") {
            hexStr = String(hexStr.dropFirst(2))
        }
        let hex = UInt(hexStr, radix: 16)!
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
