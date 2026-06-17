//
//  CoffeeDetail.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

import Foundation

struct CoffeeDetail: Identifiable, Codable, Hashable {
    let id: String
    let categoryId: String
    let name: String
    let description: String
    let longDescription: String
    let rating: Double
    let price: Double
    let imageURL: URL
    let sizes: [CoffeeSize]
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}
