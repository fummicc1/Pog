//
//  SearchConfiguration.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/03.
//

import Foundation


extension Model {
    public struct SearchConfiguration {
        public var searchedWords: [String] = []
        public var numberOfSearchPerDay: Int = 0
        public var lastSearchedDate: Date?
    }
}
