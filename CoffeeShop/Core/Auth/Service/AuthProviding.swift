//
//  AuthProviding.swift
//  CoffeeShop
//

import Foundation

protocol AuthProviding: AnyObject {
    var isLoggedIn: Bool { get }
    func currentSession() -> AuthSession?
    func signIn(email: String, password: String) async throws -> AuthSession
    func signInWithGoogle() async throws -> AuthSession
    func signInWithApple() async throws -> AuthSession
    func signOut() throws
}
