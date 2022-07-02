//
//  APIClient.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/07/02.
//

import Foundation
import Moya

public protocol APIClient {
    func request<Response: Codable>(with target: PlacesTarget) async throws -> Response
    func request(with target: PlacesTarget) async throws
}

public class APIClientImpl {
    
}
