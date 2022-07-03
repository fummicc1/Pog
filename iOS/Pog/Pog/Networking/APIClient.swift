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

public enum APIClientError: Error {
    case invalidResponse(data: Data)
    case faildToDecodeCodable(json: [String: String])
    case underlying(Error)
}

public class APIClientImpl {
    private let placesProvider = MoyaProvider<PlacesTarget>()
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension APIClientImpl: APIClient {
    public func request(with target: PlacesTarget) async throws {
        let _: Void = try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.placesProvider.request(target, completion: { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: APIClientError.underlying(error))
                case .success:
                    continuation.resume(returning: ())
                }
            })
        })
    }

    public func request<Response>(with target: PlacesTarget) async throws -> Response where Response : Decodable, Response : Encodable {
        let response: Response = try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.placesProvider.request(target, completion: { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: APIClientError.underlying(error))
                case .success(let response):
                    do {
                        if let codableResponse = try self?.jsonDecoder.decode(Response.self, from: response.data) {
                            continuation.resume(returning: codableResponse)
                        } else if let json = try JSONSerialization.jsonObject(with: response.data) as? [String: String] {
                            continuation.resume(throwing: APIClientError.faildToDecodeCodable(json: json))
                        } else {
                            continuation.resume(throwing: APIClientError.invalidResponse(data: response.data))
                        }
                    } catch {
                        continuation.resume(throwing: APIClientError.underlying(error))
                    }
                }
            })
        })
        return response
    }
}
