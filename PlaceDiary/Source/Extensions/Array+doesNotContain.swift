//
//  Array+doesNotContains.swift
//  ToiletMap
//
//  Created by Fumiya Tanaka on 2020/01/06.
//

import Foundation

extension Array where Element: Equatable {
    func doesNotContain(_ element: Element) -> Bool { !contains(element) }
}
