//
//  HomeViewModel.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation
import Observation

@Observable @MainActor
final class HomeViewModel {

    var categories = [CoffeeCategory]()
    var coffees = [Coffee]()
    var selectedCategoryId: String?
    var selectedCoffee: Coffee?
    
    private let service: any CoffeeCatalogProviding
    private var categoriesCopy = [CoffeeCategory]()
    private var coffeesCopy = [Coffee]()
    
    init(service: any CoffeeCatalogProviding) {
        self.service = service
        
        Task {
            await fetchCategories()
            await fetchCoffees()
        }
    }
}

// MARK: - Private Methods
private extension HomeViewModel {
    
    func fetchCategories() async {
        do {
            let categories = try await service.fetchCoffeeCategories()
            self.categories = categories
            self.categoriesCopy = categories
            
            // Set first category as selected by default
            if let firstCategory = categories.first {
                selectedCategoryId = firstCategory.id
                updateCategoriesSelection()
            }
        } catch {
            print("[DEBUG]: Error fetching categories: \(error)")
        }
    }
    
    func fetchCoffees() async {
        do {
            let coffees = try await service.fetchCoffees()
            self.coffees = coffees
            self.coffeesCopy = coffees
        } catch {
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
extension HomeViewModel {
    
    func handleCategorySelectionWith(_ categoryId: String) {
        selectedCategoryId = categoryId
        updateCategoriesSelection()
    }
    
    func getSelectedCategory() -> CoffeeCategory? {
        return categories.first { $0.id == selectedCategoryId }
    }
    
    func handleCoffeeSelectionWith(_ coffee: Coffee) {
        selectedCoffee = coffee
    }
}
