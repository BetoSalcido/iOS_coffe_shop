//
//  NetworkError.swift
//  CoffeeShop
//

import Foundation

extension NetworkingService {

    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int, body: String?)
        case decodingFailed(underlying: Error)
        case transportError(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The request URL is invalid."
            case .invalidResponse:
                return "The server returned an invalid response."
            case .httpError(let statusCode, let body):
                if let body, !body.isEmpty {
                    return "Request failed (\(statusCode)): \(body)"
                }
                return "Request failed with status code \(statusCode)."
            case .decodingFailed:
                return "Could not read the server response."
            case .transportError(let underlying):
                return underlying.localizedDescription
            }
        }
    }
}
