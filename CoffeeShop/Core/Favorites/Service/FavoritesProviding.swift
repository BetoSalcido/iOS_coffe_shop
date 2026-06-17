//
//  FavoritesProviding.swift
//  CoffeeShop
//

import Foundation

protocol FavoritesProviding: AnyObject {
    func fetchFavoriteCoffeeIds() async throws -> [String]
    func addFavorite(coffeeId: String) async throws
    func removeFavorite(coffeeId: String) async throws
}
