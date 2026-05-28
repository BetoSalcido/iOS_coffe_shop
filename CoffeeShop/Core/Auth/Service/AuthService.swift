//
//  AuthService.swift
//  CoffeeShop
//

import Foundation

final class AuthService: AuthProviding {

    func signIn(email: String, password: String) async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard trimmedEmail.contains("@") else {
            throw AuthError.invalidEmail
        }

        return AuthSession(id: UUID().uuidString, email: trimmedEmail)
    }

    func signInWithGoogle() async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)
        return AuthSession(id: UUID().uuidString, email: "google.user@example.com")
    }

    func signInWithApple() async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)
        return AuthSession(id: UUID().uuidString, email: "apple.user@example.com")
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case invalidEmail

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Please enter your email and password."
        case .invalidEmail:
            return "Please enter a valid email address."
        }
    }
}
