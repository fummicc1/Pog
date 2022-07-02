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
        ""
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        .requestPlain
    }

    public var headers: [String : String]? {
        nil
    }

    public var baseURL: URL {
        URL(string: "https://maps.googleapis.com/maps/api/place/json")!
    }
}
