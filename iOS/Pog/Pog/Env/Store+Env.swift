import SwiftUI

struct StoreEnvironemtnKey: EnvironmentKey {
    static var defaultValue: LocalDataStore = LocalDataStoreImpl()
}

extension EnvironmentValues {
    var store: LocalDataStore {
        get {
            self[StoreEnvironemtnKey.self]
        }
        set {
            self[StoreEnvironemtnKey.self] = newValue
        }
    }
}
