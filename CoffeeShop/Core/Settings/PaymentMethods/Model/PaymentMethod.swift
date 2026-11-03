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
        String(
            format: "%02d/%02d",
            expirationMonth,
            expirationYear % CardFormLimit.twoDigitYearBoundary
        )
    }
}

enum CardBrand: String, Codable, CaseIterable, Hashable {
    case visa
    case mastercard
    case amex
    case unknown

    var displayName: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .amex: return "Amex"
        case .unknown: return "Card"
        }
    }

    /// Brand from the PAN prefix. Length and Luhn are checked separately in `CardFormLimit`.
    static func infer(fromCardNumber digits: String) -> CardBrand {
        let cleaned = digits.filter(\.isNumber)
        if CardFormLimit.amexPrefixes.contains(where: cleaned.hasPrefix) { return .amex }
        if cleaned.hasPrefix(CardFormLimit.visaPrefix) { return .visa }
        if let twoDigit = Int(cleaned.prefix(2)),
           CardFormLimit.mastercardTwoDigitPrefix.contains(twoDigit) {
            return .mastercard
        }
        if cleaned.count >= 4,
           let fourDigit = Int(cleaned.prefix(4)),
           CardFormLimit.mastercardFourDigitPrefix.contains(fourDigit) {
            return .mastercard
        }
        return .unknown
    }
}
