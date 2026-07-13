//
//  PaymentMethodsService.swift
//  CoffeeShop
//

import Foundation

/// In-memory mock for previews and local development without Supabase.
final class PaymentMethodsService: PaymentMethodsProviding {

    private var methods: [PaymentMethod] = []

    func fetchPaymentMethods() async throws -> [PaymentMethod] {
        methods.sorted { lhs, rhs in
            if lhs.isDefault != rhs.isDefault { return lhs.isDefault && !rhs.isDefault }
            return lhs.cardholderName < rhs.cardholderName
        }
    }

    func addPaymentMethod(_ form: NewPaymentMethodForm) async throws {
        try validate(form)

        if form.setAsDefault {
            methods = methods.map {
                var copy = $0
                copy.isDefault = false
                return copy
            }
        }

        let month = Int(form.expirationMonth) ?? 1
        let year = normalizedYear(form.expirationYear)

        methods.append(
            PaymentMethod(
                id: UUID().uuidString,
                brand: form.inferredBrand,
                last4: form.last4,
                cardholderName: form.cardholderName.trimmingCharacters(in: .whitespacesAndNewlines),
                expirationMonth: month,
                expirationYear: year,
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

    private func validate(_ form: NewPaymentMethodForm) throws {
        let name = form.cardholderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { throw PaymentMethodFormError.missingCardholderName }

        let digits = form.digitsOnlyCardNumber
        guard (13...19).contains(digits.count) else { throw PaymentMethodFormError.invalidCardNumber }

        guard let month = Int(form.expirationMonth), (1...12).contains(month) else {
            throw PaymentMethodFormError.invalidExpiration
        }
        let year = normalizedYear(form.expirationYear)
        guard year >= Calendar.current.component(.year, from: Date()) - 1 else {
            throw PaymentMethodFormError.invalidExpiration
        }

        let cvvDigits = form.cvv.filter(\.isNumber)
        let expectedCVVLength = form.inferredBrand == .amex ? 4 : 3
        guard cvvDigits.count == expectedCVVLength else { throw PaymentMethodFormError.invalidCVV }
    }

    private func normalizedYear(_ raw: String) -> Int {
        let digits = raw.filter(\.isNumber)
        guard let value = Int(digits) else { return 0 }
        return value < 100 ? 2000 + value : value
    }
}
