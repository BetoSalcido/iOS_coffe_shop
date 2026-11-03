//
//  NewPaymentMethodForm.swift
//  CoffeeShop
//

import Foundation

/// Mutable form state for `AddPaymentMethodView`. Never persist `cardNumber` / `cvv`.
struct NewPaymentMethodForm {
    var cardholderName = ""
    var cardNumber = ""
    var expirationMonth = ""
    var expirationYear = ""
    var cvv = ""
    var setAsDefault = false

    var digitsOnlyCardNumber: String {
        cardNumber.filter(\.isNumber)
    }

    var last4: String {
        String(digitsOnlyCardNumber.suffix(4))
    }

    var inferredBrand: CardBrand {
        CardBrand.infer(fromCardNumber: digitsOnlyCardNumber)
    }

    var expirationInput: String {
        if expirationMonth.isEmpty && expirationYear.isEmpty { return "" }
        if expirationYear.isEmpty { return expirationMonth }
        return "\(expirationMonth)/\(expirationYear)"
    }

    var previewBrandName: String {
        digitsOnlyCardNumber.isEmpty ? "VISA" : inferredBrand.displayName.uppercased()
    }

    var previewCardNumber: String {
        cardNumber.isEmpty ? "•••• •••• •••• ••••" : cardNumber
    }

    var previewCardholderName: String {
        let trimmed = cardholderName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "YOUR NAME" : trimmed.uppercased()
    }

    var previewExpiration: String {
        expirationInput.isEmpty ? "MM/YY" : expirationInput
    }

    mutating func updateCardNumber(_ raw: String) {
        let digits = raw.filter(\.isNumber).prefix(19)
        var formatted = ""
        for (index, character) in digits.enumerated() {
            if index > 0, index.isMultiple(of: 4) {
                formatted.append(" ")
            }
            formatted.append(character)
        }
        cardNumber = formatted
    }

    mutating func updateExpiration(_ raw: String) {
        let digits = raw.filter(\.isNumber).prefix(4)
        expirationMonth = String(digits.prefix(2))
        expirationYear = digits.count > 2 ? String(digits.dropFirst(2)) : ""
    }

    mutating func updateCVV(_ raw: String) {
        cvv = String(raw.filter(\.isNumber).prefix(4))
    }
}

enum PaymentMethodFormError: LocalizedError {
    case missingCardholderName
    case invalidCardNumber
    case invalidExpiration
    case invalidCVV

    var errorDescription: String? {
        switch self {
        case .missingCardholderName:
            return "Enter the name on the card."
        case .invalidCardNumber:
            return "Enter a valid card number."
        case .invalidExpiration:
            return "Enter a valid expiration date."
        case .invalidCVV:
            return "Enter a valid CVV."
        }
    }
}
