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
