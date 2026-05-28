//
//  AuthRouter.swift
//  CoffeeShop
//

import Foundation

/// Supabase Auth routes (`auth/v1`). Wire when replacing mock `AuthService`.
enum AuthRouter: URLRequestConvertible {
    case signIn(email: String, password: String)
    case signUp(email: String, password: String)

    private var path: String {
        switch self {
        case .signIn:
            return "/token?grant_type=password"
        case .signUp:
            return "/signup"
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .signIn, .signUp:
            return .post
        }
    }

    private var body: Data? {
        let payload: [String: String]
        switch self {
        case .signIn(let email, let password):
            payload = ["email": email, "password": password]
        case .signUp(let email, let password):
            payload = ["email": email, "password": password]
        }
        return try? JSONSerialization.data(withJSONObject: payload)
    }

    func makeURLRequest() throws -> URLRequest {
        guard let url = URL(string: NetworkingService.APIConfig.authBaseURL + path) else {
            throw NetworkingService.NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
