//
//  CoffeeDetailsRouter.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

import Foundation

/// Supabase PostgREST routes for coffee detail (`rest/v1/coffees` by id).
enum CoffeeDetailsRouter: URLRequestConvertible {
    case fetchCoffeeDetail(id: String)

    private var method: HTTPMethod {
        switch self {
        case .fetchCoffeeDetail:
            return .get
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let base = NetworkingService.APIConfig.restBaseURL
        let url: URL

        switch self {
        case .fetchCoffeeDetail(let id):
            var components = URLComponents(string: base + "/coffees")
            components?.queryItems = [URLQueryItem(name: "id", value: "eq.\(id)")]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
