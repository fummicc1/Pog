//
//  PlacesTarget.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/02.
//

import Foundation
import Moya


public enum PlacesTarget {
    case search(text: String)
}

// TODO: API Endpoint
extension PlacesTarget: TargetType {
    public var path: String {
        switch self {
        case .search:
            return "textsearch/json"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .search(let text):
            return .requestParameters(
                parameters: [
                    "query": text,
                    "key": Const.googlePlacesApiKey
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String : String]? {
        nil
    }

    public var baseURL: URL {
        URL(string: "https://maps.googleapis.com/maps/api/place/")!
    }
}
