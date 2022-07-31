import Foundation

public enum Const {
    static var googlePlacesApiKey: String {
        Secret.googlePlacesApiKey
    }
    static let defaultDesiredAccuracy: Double = 100
    static let numberOfPlacesApiCallPerDay: Int = 60
}

extension Const {
    public enum UserDefaults {
        static let searchedWords = "searchedWords"
        static let numberOfSearchPerDay: String = "numberOfSearchPerDay"
        static let lastSearchedDate: String = "lastSearchedDate"
    }
}
