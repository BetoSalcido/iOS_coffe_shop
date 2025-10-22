//
//  Coffee.swift
//  CoffeShop
//
//  Created by Beto Salcido on 14/10/25.
//

import Foundation

struct Coffee: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let longDescription: String
    let rating: Double
    let price: Double
    let imageURL: String
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}
