//
//  RemoteAuthService.swift
//  CoffeeShop
//

import Foundation

/// Supabase Auth (`auth/v1`) with session persisted in Keychain.
final class RemoteAuthService: AuthProviding {

    private let network: any NetworkProviding
    private let sessionStore: any SessionStoring

    init(
        network: any NetworkProviding,
        sessionStore: any SessionStoring
    ) {
        self.network = network
        self.sessionStore = sessionStore
    }

    var isLoggedIn: Bool {
        sessionStore.isLoggedIn
    }

    func currentSession() -> AuthSession? {
        sessionStore.load()
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        let trimmedEmail = try validateEmail(email)
        guard !password.isEmpty else {
            throw AuthError.invalidCredentials
        }

        return try await authenticate(
            router: .signIn(email: trimmedEmail, password: password)
        )
    }

    func signUp(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> AuthSession {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = try validateEmail(email)

        guard !trimmedName.isEmpty else {
            throw AuthError.missingName
        }
        guard !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard password == confirmPassword else {
            throw AuthError.passwordMismatch
        }

        return try await authenticate(
            router: .signUp(
                email: trimmedEmail,
                password: password,
                fullName: trimmedName
            )
        )
    }

    func signInWithGoogle() async throws -> AuthSession {
        throw AuthError.socialSignInNotSupported
    }

    func signInWithApple() async throws -> AuthSession {
        throw AuthError.socialSignInNotSupported
    }

    func signOut() throws {
        try sessionStore.clear()
    }
}

// MARK: - Private Methods
private extension RemoteAuthService {

    func authenticate(router: AuthRouter) async throws -> AuthSession {
        do {
            let dto: AuthSessionDTO = try await network.request(AuthSessionDTO.self, router: router)
            let session = try dto.toDomain()
            try sessionStore.save(session)
            return session
        } catch let error as AuthError {
            throw error
        } catch let error as NetworkingService.NetworkError {
            throw mapNetworkError(error)
        } catch {
            throw AuthError.server(message: error.localizedDescription)
        }
    }

    func validateEmail(_ email: String) throws -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard trimmed.contains("@") else {
            throw AuthError.invalidEmail
        }
        return trimmed
    }

    func mapNetworkError(_ error: NetworkingService.NetworkError) -> AuthError {
        switch error {
        case .httpError(let statusCode, let body):
            if statusCode == 400 || statusCode == 401 {
                return .invalidCredentials
            }
            if let body, !body.isEmpty {
                return .server(message: body)
            }
            return .server(message: "Authentication failed (\(statusCode)).")
        case .decodingFailed:
            return .server(message: "Unexpected response from the server.")
        case .transportError(let underlying):
            return .server(message: underlying.localizedDescription)
        case .invalidURL, .invalidResponse:
            return .server(message: "Could not reach the authentication service.")
        }
    }
}
