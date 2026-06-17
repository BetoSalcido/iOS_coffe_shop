//
//  CoffeeCatalogService.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

final class CoffeeCatalogService: CoffeeCatalogProviding {

    func fetchCoffeeCategories() async throws -> [CoffeeCategory] {
        return DeveloperPreview().categories
    }

    func fetchCoffees(forCategory category: CoffeeCategory) async throws -> [Coffee] {
        let allCoffees = DeveloperPreview().coffees
        guard !category.isAllFilter else {
            return allCoffees
        }
        return allCoffees.filter { $0.categoryId == category.id }
    }

    func fetchCoffees(ids: [String]) async throws -> [Coffee] {
        guard !ids.isEmpty else { return [] }
        let allCoffees = DeveloperPreview().coffees
        let idSet = Set(ids)
        return allCoffees.filter { idSet.contains($0.id) }
    }
}
