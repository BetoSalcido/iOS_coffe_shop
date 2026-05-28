//
//  CoffeeRouter.swift
//  CoffeeShop
//

import Foundation

/// Supabase PostgREST routes for the catalog (`rest/v1`).
enum CoffeeRouter: URLRequestConvertible {
    case fetchCoffees
    case fetchCoffee(id: String)
    case fetchCategories

    private var method: HTTPMethod {
        switch self {
        case .fetchCoffees, .fetchCoffee, .fetchCategories:
            return .get
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let base = NetworkingService.APIConfig.restBaseURL
        let url: URL

        switch self {
        case .fetchCoffees:
            guard let built = URL(string: base + "/coffees") else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .fetchCoffee(let id):
            var components = URLComponents(string: base + "/coffees")
            components?.queryItems = [URLQueryItem(name: "id", value: "eq.\(id)")]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .fetchCategories:
            guard let built = URL(string: base + "/coffee_categories") else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
