//
//  AuthSession.swift
//  CoffeeShop
//

import Foundation

struct AuthSession: Hashable, Codable {
    let id: String
    let email: String
    let fullName: String?
    let accessToken: String
    let refreshToken: String?
}
