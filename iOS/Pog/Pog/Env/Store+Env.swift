import SwiftUI

struct StoreEnvironemtnKey: EnvironmentKey {
    static var defaultValue: Store = StoreImpl.shared
}

extension EnvironmentValues {
    var store: Store {
        get {
            self[StoreEnvironemtnKey.self]
        }
        set {
            self[StoreEnvironemtnKey.self] = newValue
        }
    }
}
