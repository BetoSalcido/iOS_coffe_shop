//
//  RemotePaymentMethodsService.swift
//  CoffeeShop
//

import Foundation

final class RemotePaymentMethodsService: PaymentMethodsProviding {

    private let network: any NetworkProviding
    private let sessionStore: any SessionStoring

    init(network: any NetworkProviding, sessionStore: any SessionStoring) {
        self.network = network
        self.sessionStore = sessionStore
    }

    func fetchPaymentMethods() async throws -> [PaymentMethod] {
        let userId = try requireUserId()
        let rows: [PaymentMethodDTO] = try await network.request(
            [PaymentMethodDTO].self,
            router: PaymentMethodsRouter.fetchMethods(userId: userId)
        )
        return rows.map { $0.toDomain() }
    }

    func addPaymentMethod(_ form: NewPaymentMethodForm) async throws {
        let userId = try requireUserId()
        try validate(form)

        if form.setAsDefault {
            try await network.perform(PaymentMethodsRouter.clearDefault(userId: userId))
        }

        let payload = PaymentMethodInsertDTO(
            userId: userId,
            brand: form.inferredBrand.rawValue,
            last4: form.last4,
            cardholderName: form.cardholderName.trimmingCharacters(in: .whitespacesAndNewlines),
            expirationMonth: Int(form.expirationMonth) ?? 1,
            expirationYear: normalizedYear(form.expirationYear),
            isDefault: form.setAsDefault
        )
        try await network.perform(PaymentMethodsRouter.addMethod(payload))
    }

    func setDefaultPaymentMethod(id: String) async throws {
        let userId = try requireUserId()
        try await network.perform(PaymentMethodsRouter.clearDefault(userId: userId))
        try await network.perform(PaymentMethodsRouter.setDefault(id: id, userId: userId))
    }

    func deletePaymentMethod(id: String) async throws {
        let userId = try requireUserId()
        try await network.perform(PaymentMethodsRouter.deleteMethod(id: id, userId: userId))
    }

    private func requireUserId() throws -> String {
        guard let userId = sessionStore.load()?.id else {
            throw PaymentMethodsError.notAuthenticated
        }
        return userId
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
