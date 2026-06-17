//
//  RemoteCoffeeCatalogService.swift
//  CoffeeShop
//

import Foundation

/// Loads catalog data from Supabase PostgREST via `NetworkProviding`.
/// Enable in `AppServiceProvider` once tables and `APIConfig` are configured.
final class RemoteCoffeeCatalogService: CoffeeCatalogProviding {

    private let network: any NetworkProviding

    init(network: any NetworkProviding) {
        self.network = network
    }

    func fetchCoffeeCategories() async throws -> [CoffeeCategory] {
        let dtos: [CoffeeCategoryDTO] = try await network.request(
            [CoffeeCategoryDTO].self,
            router: CoffeeRouter.fetchCategories
        )
        return dtos.map { $0.toDomain() }
    }

    func fetchCoffees(forCategory category: CoffeeCategory) async throws -> [Coffee] {
        let router = CoffeeRouter.fetchCoffees(
            categoryId: category.isAllFilter ? nil : category.id
        )

        let dtos: [CoffeeDTO] = try await network.request(
            [CoffeeDTO].self,
            router: router
        )
        return dtos.map { $0.toDomain() }
    }

    func fetchCoffees(ids: [String]) async throws -> [Coffee] {
        guard !ids.isEmpty else { return [] }

        let dtos: [CoffeeDTO] = try await network.request(
            [CoffeeDTO].self,
            router: CoffeeRouter.fetchCoffeesByIds(ids: ids)
        )
        return dtos.map { $0.toDomain() }
    }
}
