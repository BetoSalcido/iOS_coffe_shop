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
    
//    func fetchCoffeeDetail(id: Int) async throws -> CoffeeDetail {
//        return DeveloperPreview().coffees.first(where: { $0.id == id }) ?? .self
//    }
}
