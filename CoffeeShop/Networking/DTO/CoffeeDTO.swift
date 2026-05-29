//
//  CoffeeDTO.swift
//  CoffeeShop
//

import Foundation

/// API model aligned with Supabase `coffees` table (decoded via `.convertFromSnakeCase`).
struct CoffeeDTO: Decodable {
    let id: String
    let name: String
    let description: String
    let longDescription: String
    let rating: Double
    let price: Double
    let imageUrl: String
    let sizes: [CoffeeSizeDTO]
}

struct CoffeeSizeDTO: Decodable {
    let id: String
    let name: String
    let isActive: Bool
}

struct CoffeeCategoryDTO: Decodable {
    let id: String
    let name: String
    let isActive: Bool
}

// MARK: - Domain Mapping
extension CoffeeDTO {

    func toDomain() -> Coffee {
        Coffee(
            id: id,
            name: name,
            description: description,
            longDescription: longDescription,
            rating: rating,
            price: price,
            imageURL: imageUrl,
            sizes: sizes.map { $0.toDomain() }
        )
    }
}

extension CoffeeSizeDTO {

    func toDomain() -> CoffeeSize {
        CoffeeSize(id: id, name: name, isActive: isActive)
    }
}

extension CoffeeCategoryDTO {

    func toDomain() -> CoffeeCategory {
        CoffeeCategory(id: id, name: name, isActive: isActive)
    }
}
