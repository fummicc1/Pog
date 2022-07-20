//
//  Language.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/20.
//

import Foundation

public enum Language: String {
    case ja
    case en

    public static func fromLocale() -> Language? {
        let lang = Locale.preferredLanguages[0]
        if lang.contains("ja") {
            return .ja
        } else if lang.contains("en") {
            return .en
        }
        return nil
    }
}
