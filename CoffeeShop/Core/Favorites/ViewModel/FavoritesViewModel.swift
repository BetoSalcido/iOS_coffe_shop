//
//  FavoritesViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class FavoritesViewModel {

    private(set) var coffees: [Coffee] = []
    private(set) var isLoading = true
    private(set) var loadError: String?
    private(set) var needsSignIn = false
    var selectedCoffee: Coffee?

    private let favoritesService: any FavoritesProviding
    private let catalogService: any CoffeeCatalogProviding

    init(favoritesService: any FavoritesProviding, catalogService: any CoffeeCatalogProviding) {
        self.favoritesService = favoritesService
        self.catalogService = catalogService
    }

    func loadFavorites() async {
        isLoading = true
        loadError = nil
        needsSignIn = false

        do {
            let favoriteIds = try await favoritesService.fetchFavoriteCoffeeIds()
            coffees = try await catalogService.fetchCoffees(ids: favoriteIds)
            isLoading = false
        } catch let error as FavoritesError {
            isLoading = false
            coffees = []
            if case .notAuthenticated = error {
                needsSignIn = true
            } else {
                loadError = error.localizedDescription
            }
        } catch {
            isLoading = false
            loadError = error.localizedDescription
        }
    }

    func handleRetryLoad() {
        Task {
            await loadFavorites()
        }
    }

    func handleCoffeeSelectionWith(_ coffee: Coffee) {
        selectedCoffee = coffee
    }
}
