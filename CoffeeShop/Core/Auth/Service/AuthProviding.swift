//
//  AuthProviding.swift
//  CoffeeShop
//

import Foundation

protocol AuthProviding: AnyObject {
    func signIn(email: String, password: String) async throws -> AuthSession
    func signInWithGoogle() async throws -> AuthSession
    func signInWithApple() async throws -> AuthSession
}
