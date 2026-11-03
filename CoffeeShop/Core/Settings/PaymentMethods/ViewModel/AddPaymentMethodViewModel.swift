//
//  AddPaymentMethodViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class AddPaymentMethodViewModel {
    var form: NewPaymentMethodForm
    private(set) var isSaving = false
    private(set) var errorMessage: String?
    private(set) var didSave = false

    private let service: any PaymentMethodsProviding

    init(
        service: any PaymentMethodsProviding,
        form: NewPaymentMethodForm = NewPaymentMethodForm(setAsDefault: true)
    ) {
        self.service = service
        self.form = form
    }

    func handleAddCard() {
        guard !isSaving else { return }
        Task { await save() }
    }

    func handleCardNumberChanged(_ raw: String) {
        form.updateCardNumber(raw)
    }

    func handleExpirationChanged(_ raw: String) {
        form.updateExpiration(raw)
    }

    func handleCVVChanged(_ raw: String) {
        form.updateCVV(raw)
    }
}

// MARK: - Private Methods
private extension AddPaymentMethodViewModel {
    func save() async {
        isSaving = true
        errorMessage = nil
        do {
            try await service.addPaymentMethod(form)
            isSaving = false
            didSave = true
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}
