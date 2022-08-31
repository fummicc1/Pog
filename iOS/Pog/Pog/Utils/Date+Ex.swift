import SwiftUI

extension Date: Identifiable {
    public var id: Double {
        timeIntervalSince1970
    }
}

private let formatter = DateFormatter()

extension Date {
    public func displayable(withTime: Bool) -> String {
        formatter.dateStyle = .short
        formatter.timeStyle = withTime ? .medium : .none
        return formatter.string(from: self)
    }
}
