//
//  SessionStoring.swift
//  CoffeeShop
//

import Foundation

/// Persists the authenticated user session between app launches.
protocol SessionStoring: AnyObject {
    var isLoggedIn: Bool { get }
    func save(_ session: AuthSession) throws
    func load() -> AuthSession?
    func clear() throws
}
