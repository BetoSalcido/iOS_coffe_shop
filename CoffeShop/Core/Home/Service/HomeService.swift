//
//  HomeService.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//


import Foundation

class HomeService {
    
    func fetchCoffeeCategories() async throws -> [CoffeeCategory] {
        return CoffeCategoriesPreview().categories
    }
}
