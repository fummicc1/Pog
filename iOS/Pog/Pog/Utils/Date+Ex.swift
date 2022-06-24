import SwiftUI

extension Date: Identifiable {
    public var id: Double {
        timeIntervalSince1970
    }
}

private let formatter = DateFormatter()

extension Date {
    public var displayable: String {
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
