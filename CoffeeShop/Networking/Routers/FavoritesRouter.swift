//
//  FavoritesRouter.swift
//  CoffeeShop
//

import Foundation

/// Supabase PostgREST routes for `user_favorites`.
enum FavoritesRouter: URLRequestConvertible {
    case fetchFavorites(userId: String)
    case addFavorite(userId: String, coffeeId: String)
    case removeFavorite(userId: String, coffeeId: String)

    private var method: HTTPMethod {
        switch self {
        case .fetchFavorites:
            return .get
        case .addFavorite:
            return .post
        case .removeFavorite:
            return .delete
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let base = NetworkingService.APIConfig.restBaseURL
        let url: URL

        switch self {
        case .fetchFavorites(let userId):
            var components = URLComponents(string: base + "/user_favorites")
            components?.queryItems = [
                URLQueryItem(name: "select", value: "coffee_id"),
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
                URLQueryItem(name: "order", value: "created_at.desc"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .addFavorite:
            guard let built = URL(string: base + "/user_favorites") else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .removeFavorite(let userId, let coffeeId):
            var components = URLComponents(string: base + "/user_favorites")
            components?.queryItems = [
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
                URLQueryItem(name: "coffee_id", value: "eq.\(coffeeId)"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        switch self {
        case .addFavorite(let userId, let coffeeId):
            let payload = UserFavoriteInsertDTO(userId: userId, coffeeId: coffeeId)
            request.httpBody = try JSONEncoder().encode(payload)

        case .fetchFavorites, .removeFavorite:
            break
        }

        if method == .delete || method == .post {
            request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        }

        return request
    }
}
