import Foundation
import SwiftUI

struct LocationManagerEnvironmentKey: EnvironmentKey {
    static var defaultValue: LocationManager = LocationManagerImpl()
}

extension EnvironmentValues {
    var locationManager: LocationManager {
        get {
            self[LocationManagerEnvironmentKey.self]
        }
        set {
            self[LocationManagerEnvironmentKey.self] = newValue
        }
    }
}
