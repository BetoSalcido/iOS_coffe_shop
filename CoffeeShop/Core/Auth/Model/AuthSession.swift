//
//  AuthSession.swift
//  CoffeeShop
//

import Foundation

struct AuthSession: Hashable, Codable {
    let id: String
    let email: String
    let accessToken: String
    let refreshToken: String?
}
