//
//  HomeViewModel.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var categories = [CoffeeCategory]()
    @Published var coffees = [Coffee]()
    @Published var selectedCategoryId: String?
    @Published var selectedCoffee: Coffee?
    
    private let service: HomeService
    private var categoriesCopy = [CoffeeCategory]()
    private var coffeesCopy = [Coffee]()
    
    init(service: HomeService) {
        self.service = service
        
        Task {
            await fetchCategories()
            await fetchCoffes()
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
    
    func fetchCoffes() async {
        do {
            let coffees = try await service.fetchCoffes()
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
    
    func handleCategorySelecionWith(_ categoryId: String) {
        selectedCategoryId = categoryId
        updateCategoriesSelection()
    }
    
    func getSelectedCategory() -> CoffeeCategory? {
        return categories.first { $0.id == selectedCategoryId }
    }
    
    func handleCoffeSelecionWith(_ coffee: Coffee) {
        selectedCoffee = coffee
    }
}
