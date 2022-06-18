import SwiftUI

extension Date: Identifiable {
    public var id: Double {
        timeIntervalSince1970
    }
}
