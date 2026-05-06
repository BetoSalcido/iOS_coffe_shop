//
//  HomeService.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//


import Foundation

class HomeService {
    
    func fetchCoffeeCategories() async throws -> [CoffeeCategory] {
        return DeveloperPreview().categories
    }
    
    func fetchCoffees() async throws -> [Coffee] {
        return DeveloperPreview().coffees
    }
    
    func fetchCoffeeDetail(_ coffeeId: String) async throws -> Coffee {
        let coffees = DeveloperPreview().coffees
        return coffees.first(where: { $0.id == coffeeId }) ?? coffees[0]
    }
}
