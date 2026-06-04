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

    func fetchCoffeeDetail(_ coffeeId: String) async throws -> Coffee {
        let dtos: [CoffeeDTO] = try await network.request(
            [CoffeeDTO].self,
            router: CoffeeRouter.fetchCoffee(id: coffeeId)
        )
        guard let dto = dtos.first else {
            throw NetworkingService.NetworkError.httpError(statusCode: 404, body: nil)
        }
        return dto.toDomain()
    }
}
