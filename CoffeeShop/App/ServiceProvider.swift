//
//  ServiceProvider.swift
//  CoffeeShop
//

import Foundation

/// Composition root: exposes app-wide service dependencies.
protocol ServiceProvider: AnyObject {
    var catalog: any CoffeeCatalogProviding { get }
    var coffeeDetails: any CoffeeDetailsProviding { get }
    var favorites: any FavoritesProviding { get }
    var order: any OrderProviding { get }
    var settings: any SettingsProviding { get }
    var auth: any AuthProviding { get }
    var paymentMethods: any PaymentMethodsProviding { get }
}

final class AppServiceProvider: ServiceProvider {

    let catalog: any CoffeeCatalogProviding
    let coffeeDetails: any CoffeeDetailsProviding
    let favorites: any FavoritesProviding
    let order: any OrderProviding
    let settings: any SettingsProviding
    let auth: any AuthProviding
    let paymentMethods: any PaymentMethodsProviding
    init(
        catalog: any CoffeeCatalogProviding = CoffeeCatalogService(),
        coffeeDetails: any CoffeeDetailsProviding = CoffeeDetailsService(),
        favorites: any FavoritesProviding = FavoritesService(),
        order: any OrderProviding = OrderService(),
        settings: any SettingsProviding = SettingsService(),
        sessionStore: any SessionStoring = KeychainSessionStore(),
        auth: (any AuthProviding)? = nil,
        paymentMethods: (any PaymentMethodsProviding)? = nil
    ) {
        self.catalog = catalog
        self.coffeeDetails = coffeeDetails
        self.favorites = favorites
        self.order = order
        self.settings = settings
        self.auth = auth ?? AuthService(sessionStore: sessionStore)
        self.paymentMethods = paymentMethods ?? PaymentMethodsService()
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
        let favorites = RemoteFavoritesService(network: apiNetwork, sessionStore: sessionStore)
        let paymentMethods = RemotePaymentMethodsService(network: apiNetwork, sessionStore: sessionStore)

        return AppServiceProvider(
            catalog: catalog,
            coffeeDetails: coffeeDetails,
            favorites: favorites,
            sessionStore: sessionStore,
            auth: auth,
            paymentMethods: paymentMethods
        )
    }
}
