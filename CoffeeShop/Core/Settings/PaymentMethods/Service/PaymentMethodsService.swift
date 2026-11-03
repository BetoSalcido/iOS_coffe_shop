//
//  PaymentMethodsService.swift
//  CoffeeShop
//

import Foundation

/// In-memory mock for previews and local development without Supabase.
final class PaymentMethodsService: PaymentMethodsProviding {

    private var methods: [PaymentMethod]

    init(methods: [PaymentMethod] = DeveloperPreview().paymentMethods) {
        self.methods = methods
    }

    func fetchPaymentMethods() async throws -> [PaymentMethod] {
        methods.sorted { lhs, rhs in
            if lhs.isDefault != rhs.isDefault { return lhs.isDefault && !rhs.isDefault }
            return lhs.cardholderName < rhs.cardholderName
        }
    }

    func addPaymentMethod(_ form: NewPaymentMethodForm) async throws {
        try form.validate()

        if form.setAsDefault {
            methods = methods.map {
                var copy = $0
                copy.isDefault = false
                return copy
            }
        }

        methods.append(
            PaymentMethod(
                id: UUID().uuidString,
                brand: form.inferredBrand,
                last4: form.last4,
                cardholderName: form.trimmedCardholderName,
                expirationMonth: form.expirationMonthNumber,
                expirationYear: form.normalizedExpirationYear,
                isDefault: form.setAsDefault || methods.isEmpty
            )
        )
    }

    func setDefaultPaymentMethod(id: String) async throws {
        methods = methods.map { method in
            var copy = method
            copy.isDefault = method.id == id
            return copy
        }
    }

    func deletePaymentMethod(id: String) async throws {
        methods.removeAll { $0.id == id }
        if !methods.contains(where: \.isDefault), let firstIndex = methods.indices.first {
            methods[firstIndex].isDefault = true
        }
    }
}
