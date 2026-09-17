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
    /// When the access token stops being valid. Nil for legacy/mock sessions.
    let expiresAt: Date?

    /// Refresh a bit before real expiry to avoid racing the clock.
    private static let refreshSkew: TimeInterval = 60

    /// Whether we should call Supabase `grant_type=refresh_token`.
    var shouldRefreshAccessToken: Bool {
        guard let refreshToken, !refreshToken.isEmpty else { return false }
        guard let expiresAt else {
            // Legacy Keychain sessions without expiry: refresh once to hydrate `expiresAt`.
            return true
        }
        return expiresAt <= Date().addingTimeInterval(Self.refreshSkew)
    }
}
