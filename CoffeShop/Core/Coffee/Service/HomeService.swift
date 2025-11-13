//
//  HomeService.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//


import Foundation

class HomeService {
    
    func fetchCoffeeCategories() async throws -> [CoffeeCategory] {
        return DeveloperPreview().categories
    }
    
    func fetchCoffes() async throws -> [Coffee] {
        return DeveloperPreview().coffees
    }
    
    func fetchCoffeeDetail(_ coffeId: String) async throws -> Coffee {
        let coffees = DeveloperPreview().coffees
        return coffees.first(where: { $0.id == coffeId }) ?? coffees[0]
    }
}
