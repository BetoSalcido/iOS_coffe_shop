//
//  PaymentMethodFormMode.swift
//  CoffeeShop
//

import Foundation

/// Add and edit are two intents into `PaymentMethodFormView`.
/// Edit carries the saved card because the form cannot rebuild a full PAN.
enum PaymentMethodFormMode: Hashable {
    case add
    case edit(PaymentMethod)
}
