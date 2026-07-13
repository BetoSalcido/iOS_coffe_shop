//
//  PaymentMethod.swift
//  CoffeeShop
//

import Foundation

struct PaymentMethod: Identifiable, Hashable {
    let id: String
    let brand: CardBrand
    let last4: String
    let cardholderName: String
    let expirationMonth: Int
    let expirationYear: Int
    var isDefault: Bool

    var displayName: String {
        "\(brand.displayName) •••• \(last4)"
    }

    var formattedExpiration: String {
        String(format: "%02d/%02d", expirationMonth, expirationYear % 100)
    }
}

enum CardBrand: String, Codable, CaseIterable, Hashable {
    case visa
    case mastercard
    case amex
    case discover
    case unknown

    var displayName: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .amex: return "Amex"
        case .discover: return "Discover"
        case .unknown: return "Card"
        }
    }

    /// Best-effort brand from digits (demo / local validation only).
    static func infer(fromCardNumber digits: String) -> CardBrand {
        let cleaned = digits.filter(\.isNumber)
        if cleaned.hasPrefix("4") { return .visa }
        if cleaned.hasPrefix("34") || cleaned.hasPrefix("37") { return .amex }
        if let prefix = Int(cleaned.prefix(2)), (51...55).contains(prefix) {
            return .mastercard
        }
        if cleaned.hasPrefix("6011") || cleaned.hasPrefix("65") { return .discover }
        return .unknown
    }
}
