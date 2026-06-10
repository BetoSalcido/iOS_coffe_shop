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
    var isLoadingCoffees = true
    var isRefreshingCoffees = false
    var loadError: String?

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
        isLoadingCoffees = true
        loadError = nil

        do {
            let categories = try await service.fetchCoffeeCategories()
            self.categories = categories

            if let firstCategory = categories.first {
                selectedCategoryId = firstCategory.id
                updateCategoriesSelection()
                await fetchCoffees(for: firstCategory, isInitialLoad: true)
            } else {
                isLoadingCoffees = false
                loadError = "No coffee categories are available."
            }
        } catch {
            isLoadingCoffees = false
            loadError = error.localizedDescription
        }
    }

    func fetchCoffees(for category: CoffeeCategory, isInitialLoad: Bool) async {
        if isInitialLoad {
            isLoadingCoffees = true
        } else {
            isRefreshingCoffees = true
        }
        loadError = nil

        defer {
            isLoadingCoffees = false
            isRefreshingCoffees = false
        }

        do {
            coffees = try await service.fetchCoffees(forCategory: category)
        } catch {
            if isInitialLoad || coffees.isEmpty {
                coffees = []
                loadError = error.localizedDescription
            }
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
        loadError = nil

        Task {
            await fetchCoffees(for: category, isInitialLoad: false)
        }
    }

    func handleRetryLoad() {
        loadError = nil

        Task {
            if categories.isEmpty {
                await fetchCategories()
            } else if let category = getSelectedCategory() {
                await fetchCoffees(for: category, isInitialLoad: coffees.isEmpty)
            }
        }
    }

    func getSelectedCategory() -> CoffeeCategory? {
        categories.first { $0.id == selectedCategoryId }
    }

    func handleCoffeeSelectionWith(_ coffee: Coffee) {
        selectedCoffee = coffee
    }
}
