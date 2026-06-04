//
//  CoffeeCategory.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

struct CoffeeCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    var isActive: Bool
    let isAllFilter: Bool

    init(id: String, name: String, isActive: Bool, isAllFilter: Bool = false) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.isAllFilter = isAllFilter
    }
}
