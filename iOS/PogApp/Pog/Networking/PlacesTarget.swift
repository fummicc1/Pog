//
//  PlacesTarget.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/02.
//

import CoreLocation
import Foundation
import Moya

public enum PlacesTarget {
    case search(text: String, location: CLLocationCoordinate2D?, lang: Language?)
}

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
        case .search(let text, let location, let language):
            var parameters: [String: Any] = [
                "query": text,
                "key": Const.googlePlacesApiKey,
            ]
            if let location = location {
                parameters["location"] =
                    "\(location.latitude),\(location.longitude)"
            }
            if let language = language {
                parameters["language"] = language.rawValue
            }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        nil
    }

    public var baseURL: URL {
        URL(string: "https://maps.googleapis.com/maps/api/place/")!
    }
}
