//
//  CardFormLimit.swift
//  CoffeeShop
//

import Foundation

/// Named limits for the add-card form. Call sites use these instead of raw numbers.
///
/// - PAN length and the Luhn check: ISO/IEC 7812-1.
/// - Visa lengths: 13, 16, or 19 digits, prefix `4`.
/// - Mastercard: 16 digits, prefixes 51–55 or 2221–2720.
/// - American Express: 15 digits, prefixes 34 or 37. CID is 4 digits; other brands use a 3-digit CVV (PCI).
/// - Expiry is typed as `MMYY`. A card stays valid through the end of that month.
enum CardFormLimit {
    static let cardNumberLength = 13...19
    static let visaLengths: Set<Int> = [13, 16, 19]
    static let mastercardLength = 16
    static let amexLength = 15
    static let cvvLength = 3
    static let amexCVVLength = 4
    static let expirationDigitCount = 4
    static let expirationMonth = 1...12
    /// `YY` means `2000 + YY`. Years already stored with a century are left as-is.
    static let twoDigitYearBoundary = 100
    static let yearCentury = 2000
    static let visaPrefix = "4"
    static let amexPrefixes = ["34", "37"]
    static let mastercardTwoDigitPrefix = 51...55
    static let mastercardFourDigitPrefix = 2221...2720

    static func accepts(length: Int, for brand: CardBrand) -> Bool {
        guard cardNumberLength.contains(length) else { return false }
        switch brand {
        case .visa:
            return visaLengths.contains(length)
        case .mastercard:
            return length == mastercardLength
        case .amex:
            return length == amexLength
        case .unknown:
            return true
        }
    }

    static func cvvLength(for brand: CardBrand) -> Int {
        brand == .amex ? amexCVVLength : cvvLength
    }

    /// ISO/IEC 7812-1 Luhn check. Doubles every second digit from the right.
    static func passesLuhn(_ digits: String) -> Bool {
        guard !digits.isEmpty, digits.allSatisfy(\.isNumber) else { return false }
        var sum = 0
        for (index, character) in digits.reversed().enumerated() {
            guard let digit = character.wholeNumberValue else { return false }
            if index.isMultiple(of: 2) {
                sum += digit
            } else {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            }
        }
        return sum.isMultiple(of: 10)
    }
}
