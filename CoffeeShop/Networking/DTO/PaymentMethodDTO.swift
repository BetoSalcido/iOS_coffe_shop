//
//  PaymentMethodDTO.swift
//  CoffeeShop
//

import Foundation

/// API model aligned with Supabase `payment_methods` (decoded via `.convertFromSnakeCase`).
struct PaymentMethodDTO: Decodable {
    let id: String
    let brand: String
    let last4: String
    let cardholderName: String
    let expirationMonth: Int
    let expirationYear: Int
    let isDefault: Bool
}

struct PaymentMethodInsertDTO: Encodable {
    let userId: String
    let brand: String
    let last4: String
    let cardholderName: String
    let expirationMonth: Int
    let expirationYear: Int
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case brand
        case last4
        case cardholderName = "cardholder_name"
        case expirationMonth = "expiration_month"
        case expirationYear = "expiration_year"
        case isDefault = "is_default"
    }
}

struct PaymentMethodDefaultUpdateDTO: Encodable {
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
    }
}

// MARK: - Domain Mapping

extension PaymentMethodDTO {

    func toDomain() -> PaymentMethod {
        PaymentMethod(
            id: id,
            brand: CardBrand(rawValue: brand) ?? .unknown,
            last4: last4,
            cardholderName: cardholderName,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            isDefault: isDefault
        )
    }
}
