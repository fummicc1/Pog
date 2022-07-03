import Foundation

enum Const {
    static var googlePlacesApiKey: String {
        Secret.googlePlacesApiKey
    }
    static let defaultDesiredAccuracy: Double = 100
    static let numberOfPlacesApiCallPerDay: Int = 60
}
