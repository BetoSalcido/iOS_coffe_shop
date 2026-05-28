//
//  ServiceProvider.swift
//  CoffeeShop
//

import Foundation

/// Composition root: exposes app-wide service dependencies.
protocol ServiceProvider: AnyObject {
    var catalog: any CoffeeCatalogProviding { get }
    var order: any OrderProviding { get }
    var settings: any SettingsProviding { get }
    var auth: any AuthProviding { get }
}

final class AppServiceProvider: ServiceProvider {

    let catalog: any CoffeeCatalogProviding
    let order: any OrderProviding
    let settings: any SettingsProviding
    let auth: any AuthProviding

    init(
        catalog: any CoffeeCatalogProviding = CoffeeCatalogService(),
        order: any OrderProviding = OrderService(),
        settings: any SettingsProviding = SettingsService(),
        sessionStore: any SessionStoring = KeychainSessionStore(),
        auth: (any AuthProviding)? = nil
    ) {
        self.catalog = catalog
        self.order = order
        self.settings = settings
        self.auth = auth ?? AuthService(sessionStore: sessionStore)
    }

    static let live = AppServiceProvider()
}
