//
//  CoffeeDetailDTO.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

import Foundation

/// API model aligned with Supabase `coffeeDetail` table (decoded via `.convertFromSnakeCase`).
struct CoffeeDetailDTO: Decodable {
    let id: String
    let categoryId: String
    let name: String
    let description: String
    let longDescription: String
    let rating: Double
    let price: Double
    let imageUrl: URL
    let sizes: [CoffeeSizeDTO]
    let modifiers: [CoffeeModifierDTO]?
}

struct CoffeeModifierDTO: Decodable {
    let id: String
    let name: String
    let isActive: Bool
}

// MARK: - Domain Mapping
extension CoffeeDetailDTO {

    func toDomain() -> CoffeeDetail {
        CoffeeDetail(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            longDescription: longDescription,
            rating: rating,
            price: price,
            imageURL: imageUrl,
            sizes: sizes.map { $0.toDomain() },
            modifiers: (modifiers ?? []).map { $0.toDomain() }
        )
    }
}

extension CoffeeModifierDTO {

    func toDomain() -> CoffeeModifier {
        CoffeeModifier(id: id, name: name, isActive: isActive)
    }
}
