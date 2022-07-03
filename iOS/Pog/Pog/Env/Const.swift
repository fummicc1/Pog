import Foundation

enum Const {
    static var googlePlacesApiKey: String {
        ProcessInfo.processInfo.environment["googlePlacesApiKey"] ?? ""
    }
}
