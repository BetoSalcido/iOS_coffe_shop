//
//  ServiceProvider.swift
//  CoffeeShop
//

import Foundation

/// Composition root: exposes app-wide service dependencies.
protocol ServiceProvider: AnyObject {
    var catalog: any CoffeeCatalogProviding { get }
    var coffeeDetails: any CoffeeDetailsProviding { get }
    var order: any OrderProviding { get }
    var settings: any SettingsProviding { get }
    var auth: any AuthProviding { get }
}

final class AppServiceProvider: ServiceProvider {

    let catalog: any CoffeeCatalogProviding
    let coffeeDetails: any CoffeeDetailsProviding
    let order: any OrderProviding
    let settings: any SettingsProviding
    let auth: any AuthProviding

    init(
        catalog: any CoffeeCatalogProviding = CoffeeCatalogService(),
        coffeeDetails: any CoffeeDetailsProviding = CoffeeDetailsService(),
        order: any OrderProviding = OrderService(),
        settings: any SettingsProviding = SettingsService(),
        sessionStore: any SessionStoring = KeychainSessionStore(),
        auth: (any AuthProviding)? = nil
    ) {
        self.catalog = catalog
        self.coffeeDetails = coffeeDetails
        self.order = order
        self.settings = settings
        self.auth = auth ?? AuthService(sessionStore: sessionStore)
    }

    static let live = AppServiceProvider()

    /// Supabase-backed catalog and auth. Requires `CoffeeShop/Secrets.plist`.
    static func liveWithSupabase(
        sessionStore: KeychainSessionStore = KeychainSessionStore()
    ) -> AppServiceProvider {
        let authNetwork = URLSessionNetworkClient()
        let apiNetwork = URLSessionNetworkClient(accessTokenProvider: sessionStore)
        let auth = RemoteAuthService(network: authNetwork, sessionStore: sessionStore)
        let catalog = RemoteCoffeeCatalogService(network: apiNetwork)
        let coffeeDetails = RemoteCoffeeDetailsService(network: apiNetwork)

        return AppServiceProvider(
            catalog: catalog,
            coffeeDetails: coffeeDetails,
            sessionStore: sessionStore,
            auth: auth
        )
    }
}
