//
//  UserFavoriteDTO.swift
//  CoffeeShop
//

import Foundation

struct UserFavoriteDTO: Decodable {
    let coffeeId: String
}

struct UserFavoriteInsertDTO: Encodable {
    let userId: String
    let coffeeId: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case coffeeId = "coffee_id"
    }
}
