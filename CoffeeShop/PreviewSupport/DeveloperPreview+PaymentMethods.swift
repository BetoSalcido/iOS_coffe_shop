// MARK: - Payment methods preview helpers

import Foundation

extension DeveloperPreview {

    /// Sample saved cards for list / empty vs non-empty SwiftUI previews.
    var paymentMethods: [PaymentMethod] {
        [
            makePaymentMethod(
                id: "c3000001-0001-4001-8001-000000000001",
                brand: .visa,
                last4: "4242",
                cardholderName: "Beto Salcido",
                expirationMonth: 12,
                expirationYear: 2028,
                isDefault: true
            ),
            makePaymentMethod(
                id: "c3000001-0001-4001-8001-000000000002",
                brand: .mastercard,
                last4: "4444",
                cardholderName: "Beto Salcido",
                expirationMonth: 6,
                expirationYear: 2027,
                isDefault: false
            ),
            makePaymentMethod(
                id: "c3000001-0001-4001-8001-000000000003",
                brand: .amex,
                last4: "0005",
                cardholderName: "Coffee Shop Guest",
                expirationMonth: 3,
                expirationYear: 2029,
                isDefault: false
            ),
        ]
    }

    /// Empty list — useful for designing the empty state.
    var emptyPaymentMethods: [PaymentMethod] { [] }

    /// Pre-filled Add form (Visa test number shape — demo only, never persist).
    var filledNewPaymentMethodForm: NewPaymentMethodForm {
        NewPaymentMethodForm(
            cardholderName: "Beto Salcido",
            cardNumber: "4242 4242 4242 4242",
            expirationMonth: "12",
            expirationYear: "28",
            cvv: "123",
            setAsDefault: true
        )
    }

    var emptyNewPaymentMethodForm: NewPaymentMethodForm {
        NewPaymentMethodForm()
    }

    static func makePaymentMethod(
        id: String,
        brand: CardBrand,
        last4: String,
        cardholderName: String,
        expirationMonth: Int,
        expirationYear: Int,
        isDefault: Bool
    ) -> PaymentMethod {
        PaymentMethod(
            id: id,
            brand: brand,
            last4: last4,
            cardholderName: cardholderName,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            isDefault: isDefault
        )
    }

    func makePaymentMethod(
        id: String,
        brand: CardBrand,
        last4: String,
        cardholderName: String,
        expirationMonth: Int,
        expirationYear: Int,
        isDefault: Bool
    ) -> PaymentMethod {
        Self.makePaymentMethod(
            id: id,
            brand: brand,
            last4: last4,
            cardholderName: cardholderName,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            isDefault: isDefault
        )
    }
}
