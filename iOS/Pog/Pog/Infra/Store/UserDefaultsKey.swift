//
//  UserDefaultsKey.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/31.
//

import Foundation

public enum UserDefaultsKey {
    case searchedWords
    case numberOfSearchPerDay
    case lastSearchedDate

    public var key: String {
        switch self {
        case .searchedWords:
            return Const.UserDefaults.searchedWords
        case .numberOfSearchPerDay:
            return Const.UserDefaults.numberOfSearchPerDay
        case .lastSearchedDate:
            return Const.UserDefaults.lastSearchedDate
        }
    }
}

// MARK: UserDefaults Observation
extension UserDefaults {
    @objc public dynamic var searchedWords: [String] {
        return array(forKey: Const.UserDefaults.searchedWords) as? [String] ?? []
    }
    @objc public dynamic var numberOfSearchPerDay: Int {
        return integer(forKey: Const.UserDefaults.numberOfSearchPerDay)
    }
    @objc public dynamic var lastSearchedDate: Double {
        return double(forKey: Const.UserDefaults.lastSearchedDate)
    }
}
