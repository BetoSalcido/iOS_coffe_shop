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

    func addPaymentMethod(_ form: PaymentMethodForm) async throws {
        let userId = try requireUserId()
        try form.validate()

        if form.setAsDefault {
            try await network.perform(PaymentMethodsRouter.clearDefault(userId: userId))
        }

        let payload = PaymentMethodInsertDTO(
            userId: userId,
            brand: form.persistedBrand.rawValue,
            last4: form.persistedLast4,
            cardholderName: form.trimmedCardholderName,
            expirationMonth: form.expirationMonthNumber,
            expirationYear: form.normalizedExpirationYear,
            isDefault: form.setAsDefault
        )
        try await network.perform(PaymentMethodsRouter.addMethod(payload))
    }

    func updatePaymentMethod(id: String, form: PaymentMethodForm) async throws {
        let userId = try requireUserId()
        try form.validate()

        if form.setAsDefault {
            try await network.perform(PaymentMethodsRouter.clearDefault(userId: userId))
        }

        let payload = PaymentMethodUpdateDTO(
            brand: form.persistedBrand.rawValue,
            last4: form.persistedLast4,
            cardholderName: form.trimmedCardholderName,
            expirationMonth: form.expirationMonthNumber,
            expirationYear: form.normalizedExpirationYear,
            isDefault: form.setAsDefault
        )
        try await network.perform(
            PaymentMethodsRouter.updateMethod(id: id, userId: userId, payload: payload)
        )
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
}
