//
//  AuthService.swift
//  CoffeeShop
//

import Foundation

final class AuthService: AuthProviding {

    private let sessionStore: any SessionStoring

    init(sessionStore: any SessionStoring = KeychainSessionStore()) {
        self.sessionStore = sessionStore
    }

    var isLoggedIn: Bool {
        sessionStore.isLoggedIn
    }

    func currentSession() -> AuthSession? {
        sessionStore.load()
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard trimmedEmail.contains("@") else {
            throw AuthError.invalidEmail
        }

        let session = AuthSession(
            id: UUID().uuidString,
            email: trimmedEmail,
            fullName: nil,
            accessToken: "mock-local",
            refreshToken: nil
        )
        try sessionStore.save(session)
        return session
    }

    func signUp(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw AuthError.missingName
        }
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard trimmedEmail.contains("@") else {
            throw AuthError.invalidEmail
        }
        guard password == confirmPassword else {
            throw AuthError.passwordMismatch
        }

        let session = AuthSession(
            id: UUID().uuidString,
            email: trimmedEmail,
            fullName: trimmedName,
            accessToken: "mock-local",
            refreshToken: nil
        )
        try sessionStore.save(session)
        return session
    }

    func signInWithGoogle() async throws -> AuthSession {
        try await signInWithSocial(email: "google.user@example.com")
    }

    func signInWithApple() async throws -> AuthSession {
        try await signInWithSocial(email: "apple.user@example.com")
    }

    func signOut() throws {
        try sessionStore.clear()
    }
}

// MARK: - Private Methods
private extension AuthService {

    func signInWithSocial(email: String) async throws -> AuthSession {
        try await Task.sleep(nanoseconds: 500_000_000)
        let session = AuthSession(
            id: UUID().uuidString,
            email: email,
            fullName: nil,
            accessToken: "mock-local",
            refreshToken: nil
        )
        try sessionStore.save(session)
        return session
    }
}
