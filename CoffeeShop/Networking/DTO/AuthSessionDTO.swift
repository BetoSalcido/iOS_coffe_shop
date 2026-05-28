//
//  AuthSessionDTO.swift
//  CoffeeShop
//

import Foundation

/// Supabase Auth token response (`POST /auth/v1/token` or signup).
struct AuthSessionDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int?
    let tokenType: String?
    let user: AuthUserDTO?
}

struct AuthUserDTO: Decodable {
    let id: String
    let email: String?
}

extension AuthSessionDTO {

    func toDomain() -> AuthSession {
        AuthSession(
            id: user?.id ?? UUID().uuidString,
            email: user?.email ?? ""
        )
    }
}
