//
//  CoffeeCatalogProviding.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/05/26.
//

import Foundation

/// Abstraction for loading catalog list data (categories, coffees). Enables injecting mocks in tests and previews.
protocol CoffeeCatalogProviding: AnyObject {
    func fetchCoffeeCategories() async throws -> [CoffeeCategory]
    func fetchCoffees(forCategory category: CoffeeCategory) async throws -> [Coffee]
}
