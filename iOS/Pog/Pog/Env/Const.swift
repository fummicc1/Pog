import Foundation

enum Const {
    static var googlePlacesApiKey: String {
        ProcessInfo.processInfo.environment["googlePlacesApiKey"] ?? ""
    }
    static let defaultDesiredAccuracy: Double = 100
    static let numberOfPlacesApiCallPerDay: Int = 60
}
