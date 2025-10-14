//
//  HomeViewModel.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var categories = [CoffeeCategory]()
    @Published var selectedCategoryId: String?
    
    private let service: HomeService
    private var categoriesCopy = [CoffeeCategory]()
    
    init(service: HomeService) {
        self.service = service
        
        Task {
            await fetchCategories()
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
    
    func selectCategory(_ categoryId: String) {
        selectedCategoryId = categoryId
        updateCategoriesSelection()
    }
    
    func getSelectedCategory() -> CoffeeCategory? {
        return categories.first { $0.id == selectedCategoryId }
    }
}
