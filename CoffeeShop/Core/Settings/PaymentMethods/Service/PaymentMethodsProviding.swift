//
//  PaymentMethodsProviding.swift
//  CoffeeShop
//

import Foundation

/// Abstraction for payment methods CRUD. Enables injecting mocks in tests and previews.
protocol PaymentMethodsProviding: AnyObject {
    func fetchPaymentMethods() async throws -> [PaymentMethod]
    func addPaymentMethod(_ form: NewPaymentMethodForm) async throws
    func setDefaultPaymentMethod(id: String) async throws
    func deletePaymentMethod(id: String) async throws
}
