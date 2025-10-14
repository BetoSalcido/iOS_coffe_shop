//
//  HomeViewModel.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var categories =  [CoffeeCategory]()
    
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
        } catch {
            print("[DEBUG]: Error fetching categories: \(error)")
        }
    }
}
