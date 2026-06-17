//
//  RemoteCoffeeDetailsService.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

import Foundation

/// Loads catalog data from Supabase PostgREST via `NetworkProviding`.
/// Enable in `AppServiceProvider` once tables and `APIConfig` are configured.
final class RemoteCoffeeDetailsService: CoffeeDetailsProviding {

    private let network: any NetworkProviding

    init(network: any NetworkProviding) {
        self.network = network
    }

    func fetchCoffeeDetail(_ coffeeId: String) async throws -> CoffeeDetail {
        let dtos: [CoffeeDetailDTO] = try await network.request(
            [CoffeeDetailDTO].self,
            router: CoffeeDetailsRouter.fetchCoffeeDetail(id: coffeeId)
        )
        guard let dto = dtos.first else {
            throw NetworkingService.NetworkError.httpError(statusCode: 404, body: nil)
        }
        return dto.toDomain()
    }
}
