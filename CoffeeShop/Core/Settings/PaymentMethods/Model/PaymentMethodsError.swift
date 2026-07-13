//
//  PaymentMethodsError.swift
//  CoffeeShop
//

import Foundation

enum PaymentMethodsError: LocalizedError {
    case notAuthenticated

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Sign in to manage payment methods."
        }
    }
}
