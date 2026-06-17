//
//  RemoteFavoritesService.swift
//  CoffeeShop
//

import Foundation

final class RemoteFavoritesService: FavoritesProviding {

    private let network: any NetworkProviding
    private let sessionStore: any SessionStoring

    init(network: any NetworkProviding, sessionStore: any SessionStoring) {
        self.network = network
        self.sessionStore = sessionStore
    }

    func fetchFavoriteCoffeeIds() async throws -> [String] {
        let userId = try requireUserId()
        let rows: [UserFavoriteDTO] = try await network.request(
            [UserFavoriteDTO].self,
            router: FavoritesRouter.fetchFavorites(userId: userId)
        )
        return rows.map(\.coffeeId)
    }

    func addFavorite(coffeeId: String) async throws {
        let userId = try requireUserId()
        try await network.perform(
            FavoritesRouter.addFavorite(userId: userId, coffeeId: coffeeId)
        )
    }

    func removeFavorite(coffeeId: String) async throws {
        let userId = try requireUserId()
        try await network.perform(
            FavoritesRouter.removeFavorite(userId: userId, coffeeId: coffeeId)
        )
    }

    private func requireUserId() throws -> String {
        guard let userId = sessionStore.load()?.id else {
            throw FavoritesError.notAuthenticated
        }
        return userId
    }
}
