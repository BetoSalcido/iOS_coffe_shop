//
//  CoffeeRouter.swift
//  CoffeeShop
//

import Foundation

/// Supabase PostgREST routes for the catalog (`rest/v1`).
enum CoffeeRouter: URLRequestConvertible {
    case fetchCoffees(categoryId: String?)
    case fetchCoffeesByIds(ids: [String])
    case fetchCategories

    private var method: HTTPMethod {
        switch self {
        case .fetchCoffees, .fetchCoffeesByIds, .fetchCategories:
            return .get
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let base = NetworkingService.APIConfig.restBaseURL
        let url: URL

        switch self {
        case .fetchCoffees(let categoryId):
            if let categoryId {
                var components = URLComponents(string: base + "/coffees")
                components?.queryItems = [
                    URLQueryItem(name: "category_id", value: "eq.\(categoryId)")
                ]
                guard let built = components?.url else {
                    throw NetworkingService.NetworkError.invalidURL
                }
                url = built
            } else {
                guard let built = URL(string: base + "/coffees") else {
                    throw NetworkingService.NetworkError.invalidURL
                }
                url = built
            }

        case .fetchCoffeesByIds(let ids):
            guard !ids.isEmpty,
                  let built = URL(string: base + "/coffees?id=in.(\(ids.joined(separator: ",")))")
            else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .fetchCategories:
            guard let built = URL(string: base + "/coffee_categories?order=sort_order.asc") else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
