//
//  PlaceManager+Env.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/06/26.
//

import Foundation
import SwiftUI

struct PlaceManagerEnvironemtKey: EnvironmentKey {
    static var defaultValue: PlaceManager = PlaceManagerImpl()
}

extension EnvironmentValues {
    var placeManager: PlaceManager {
        get {
            self[PlaceManagerEnvironemtKey.self]
        }
        set {
            self[PlaceManagerEnvironemtKey.self] = newValue
        }
    }
}
