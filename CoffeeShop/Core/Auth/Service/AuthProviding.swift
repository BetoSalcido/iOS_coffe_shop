//
//  AuthProviding.swift
//  CoffeeShop
//

import Foundation

protocol AuthProviding: AnyObject {
    var isLoggedIn: Bool { get }
    func currentSession() -> AuthSession?
    func signIn(email: String, password: String) async throws -> AuthSession
    func signUp(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> AuthSession
    func signInWithGoogle() async throws -> AuthSession
    func signInWithApple() async throws -> AuthSession
    /// Renews the access token when it is expired (or about to). Clears Keychain if refresh fails.
    func refreshSessionIfNeeded() async throws
    func signOut() throws
}
