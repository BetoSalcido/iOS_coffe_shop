//
//  FavoritesService.swift
//  CoffeeShop
//

import Foundation

/// In-memory favorites for previews and offline mock builds.
final class FavoritesService: FavoritesProviding {

    private var favoriteIds: Set<String> = []

    func fetchFavoriteCoffeeIds() async throws -> [String] {
        Array(favoriteIds)
    }

    func addFavorite(coffeeId: String) async throws {
        favoriteIds.insert(coffeeId)
    }

    func removeFavorite(coffeeId: String) async throws {
        favoriteIds.remove(coffeeId)
    }
}
