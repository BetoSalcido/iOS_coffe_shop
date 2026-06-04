//
//  CoffeeCatalogViewModel.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation
import Observation

@Observable @MainActor
final class CoffeeCatalogViewModel {

    var categories = [CoffeeCategory]()
    var coffees = [Coffee]()
    var selectedCategoryId: String?
    var selectedCoffee: Coffee?
    var isLoadingCoffees = false

    private let service: any CoffeeCatalogProviding

    init(service: any CoffeeCatalogProviding) {
        self.service = service

        Task {
            await fetchCategories()
        }
    }
}

// MARK: - Private Methods
private extension CoffeeCatalogViewModel {

    func fetchCategories() async {
        do {
            let categories = try await service.fetchCoffeeCategories()
            self.categories = categories

            if let firstCategory = categories.first {
                selectedCategoryId = firstCategory.id
                updateCategoriesSelection()
                await fetchCoffees(for: firstCategory)
            }
        } catch {
            print("[DEBUG]: Error fetching categories: \(error)")
        }
    }

    func fetchCoffees(for category: CoffeeCategory) async {
        isLoadingCoffees = true

        do {
            coffees = try await service.fetchCoffees(forCategory: category)
            isLoadingCoffees = false
        } catch {
            coffees = []
            isLoadingCoffees = false
            print("[DEBUG]: Error fetching coffees: \(error)")
        }
    }

    func updateCategoriesSelection() {
        categories = categories.map { category in
            var updatedCategory = category
            updatedCategory.isActive = (category.id == selectedCategoryId)
            return updatedCategory
        }
    }
}

// MARK: - Public Methods
extension CoffeeCatalogViewModel {

    func handleCategorySelectionWith(_ categoryId: String) {
        guard categoryId != selectedCategoryId,
              let category = categories.first(where: { $0.id == categoryId }) else {
            return
        }

        selectedCategoryId = categoryId
        updateCategoriesSelection()

        Task {
            await fetchCoffees(for: category)
        }
    }

    func getSelectedCategory() -> CoffeeCategory? {
        categories.first { $0.id == selectedCategoryId }
    }

    func handleCoffeeSelectionWith(_ coffee: Coffee) {
        selectedCoffee = coffee
    }
}
