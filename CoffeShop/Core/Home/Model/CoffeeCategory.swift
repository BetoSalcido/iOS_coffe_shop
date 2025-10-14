//
//  CoffeeCategory.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

struct CoffeeCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    var isActive: Bool
}
