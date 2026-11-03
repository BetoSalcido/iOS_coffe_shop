//
//  AddPaymentMethodViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class AddPaymentMethodViewModel {
    var form: NewPaymentMethodForm
    /// Bumped after each keystroke so the button refreshes. UIKit edits do not
    /// always invalidate SwiftUI in the same turn as the form write.
    private(set) var inputRevision = 0
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

    var canSubmit: Bool {
        _ = inputRevision
        return form.isValid && !isSaving
    }

    func handleAddCard() {
        guard canSubmit else { return }
        Task { await save() }
    }

    func handleCardholderNameChanged(_ raw: String) {
        form.updateCardholderName(raw)
        scheduleButtonRefresh()
    }

    func handleCardNumberChanged(_ raw: String) {
        form.updateCardNumber(raw)
        scheduleButtonRefresh()
    }

    func handleExpirationChanged(_ raw: String) {
        form.updateExpiration(raw)
        scheduleButtonRefresh()
    }

    func handleCVVChanged(_ raw: String) {
        form.updateCVV(raw)
        scheduleButtonRefresh()
    }

    private func scheduleButtonRefresh() {
        Task { @MainActor in
            inputRevision += 1
        }
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
