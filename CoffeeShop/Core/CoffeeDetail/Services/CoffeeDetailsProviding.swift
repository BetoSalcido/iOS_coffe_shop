//
//  CoffeeDetailsProviding.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

/// Abstraction for loading catalog data (detail). Enables injecting mocks in tests and previews.
protocol CoffeeDetailsProviding: AnyObject {
    func fetchCoffeeDetail(_ coffeeId: String) async throws -> CoffeeDetail
}
