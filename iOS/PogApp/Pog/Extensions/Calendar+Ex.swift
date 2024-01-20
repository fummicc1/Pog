import Foundation

extension Calendar {
    func tomorrow(of date: Date) -> Date {
        var components = self.dateComponents([.year, .month, .day], from: date)
        components.calendar = self
        components.day? += 1
        guard let tmr = components.date else {
            assertionFailure("failed to create date from DateComponents")
            return date
        }
        return tmr
    }
}
