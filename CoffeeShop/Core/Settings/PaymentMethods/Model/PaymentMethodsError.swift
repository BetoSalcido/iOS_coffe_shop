//
//  PaymentMethodsError.swift
//  CoffeeShop
//

import Foundation

enum PaymentMethodsError: LocalizedError {
    case notAuthenticated
    case missingPaymentMethod

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Sign in to manage payment methods."
        case .missingPaymentMethod:
            return "That card is no longer saved."
        }
    }
}
