//
//  PaymentMethodsRouter.swift
//  CoffeeShop
//

import Foundation

/// Supabase PostgREST routes for `payment_methods`.
enum PaymentMethodsRouter: URLRequestConvertible {
    case fetchMethods(userId: String)
    case addMethod(PaymentMethodInsertDTO)
    case setDefault(id: String, userId: String)
    case clearDefault(userId: String)
    case deleteMethod(id: String, userId: String)

    private var method: HTTPMethod {
        switch self {
        case .fetchMethods:
            return .get
        case .addMethod:
            return .post
        case .setDefault, .clearDefault:
            return .patch
        case .deleteMethod:
            return .delete
        }
    }

    func makeURLRequest() throws -> URLRequest {
        let base = NetworkingService.APIConfig.restBaseURL
        let url: URL

        switch self {
        case .fetchMethods(let userId):
            var components = URLComponents(string: base + "/payment_methods")
            components?.queryItems = [
                URLQueryItem(name: "select", value: "id,brand,last4,cardholder_name,expiration_month,expiration_year,is_default"),
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
                URLQueryItem(name: "order", value: "is_default.desc,created_at.desc"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .addMethod:
            guard let built = URL(string: base + "/payment_methods") else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .setDefault(let id, let userId):
            var components = URLComponents(string: base + "/payment_methods")
            components?.queryItems = [
                URLQueryItem(name: "id", value: "eq.\(id)"),
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .clearDefault(let userId):
            var components = URLComponents(string: base + "/payment_methods")
            components?.queryItems = [
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
                URLQueryItem(name: "is_default", value: "eq.true"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built

        case .deleteMethod(let id, let userId):
            var components = URLComponents(string: base + "/payment_methods")
            components?.queryItems = [
                URLQueryItem(name: "id", value: "eq.\(id)"),
                URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            ]
            guard let built = components?.url else {
                throw NetworkingService.NetworkError.invalidURL
            }
            url = built
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        switch self {
        case .addMethod(let payload):
            request.httpBody = try JSONEncoder().encode(payload)

        case .setDefault:
            request.httpBody = try JSONEncoder().encode(PaymentMethodDefaultUpdateDTO(isDefault: true))

        case .clearDefault:
            request.httpBody = try JSONEncoder().encode(PaymentMethodDefaultUpdateDTO(isDefault: false))

        case .fetchMethods, .deleteMethod:
            break
        }

        if method == .post || method == .patch || method == .delete {
            request.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        }

        return request
    }
}
