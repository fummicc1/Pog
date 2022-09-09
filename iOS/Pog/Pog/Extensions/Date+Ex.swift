import Foundation
import SwiftUI

extension Date {
    func dropTime(locale: Locale? = nil) -> Date {
        let locale = locale ?? NSLocale(localeIdentifier: Locale.preferredLanguages[0]) as Locale
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = locale
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.calendar = calendar
        guard let date = components.date else {
            assertionFailure("Fail to drop time")
            return self
        }
        return date
    }
}

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
