//
//  PaymentMethodFormViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class PaymentMethodFormViewModel {
    let mode: PaymentMethodFormMode
    var form: PaymentMethodForm
    /// Bumped after each keystroke so the button refreshes. UIKit edits do not
    /// always invalidate SwiftUI in the same turn as the form write.
    private(set) var inputRevision = 0
    private(set) var isSaving = false
    private(set) var isDeleting = false
    var showsRemoveConfirmation = false
    private(set) var errorMessage: String?
    private(set) var didSave = false
    private(set) var didDelete = false

    private let service: any PaymentMethodsProviding

    init(
        service: any PaymentMethodsProviding,
        mode: PaymentMethodFormMode = .add,
        form: PaymentMethodForm? = nil
    ) {
        self.service = service
        self.mode = mode
        if let form {
            self.form = form
        } else {
            switch mode {
            case .add:
                self.form = PaymentMethodForm(setAsDefault: true)
            case .edit(let method):
                self.form = .editing(method)
            }
        }
    }

    var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    var title: String {
        isEditing ? "Edit Payment Method" : "Add Payment Method"
    }

    var subtitle: String {
        isEditing
            ? "Update the name, expiry, or default card. The full number is not stored."
            : "Securely save your payment details for a faster checkout ritual."
    }

    var submitTitle: String {
        isEditing ? "Save Changes" : "Add Card"
    }
    
    var deleteTitle: String {
        "Delete Payment Method"
    }

    var cardNumberPlaceholder: String {
        if case .edit(let method) = mode {
            return "•••• •••• •••• \(method.last4)"
        }
        return "0000000000000000"
    }

    var canSubmit: Bool {
        _ = inputRevision
        return form.isValid && !isSaving && !isDeleting
    }

    /// Brand and last four of the saved card this dialog would remove.
    var removeBrandName: String {
        if case .edit(let method) = mode {
            return method.brand.displayName
        }
        return form.persistedBrand.displayName
    }

    var removeLast4: String {
        if case .edit(let method) = mode {
            return method.last4
        }
        return form.persistedLast4
    }

    func handleSubmit() {
        guard canSubmit else { return }
        Task { await save() }
    }

    func handleDelete() {
        guard isEditing, !isSaving, !isDeleting else { return }
        errorMessage = nil
        showsRemoveConfirmation = true
    }

    func handleCancelDelete() {
        guard !isDeleting else { return }
        showsRemoveConfirmation = false
    }

    func handleConfirmDelete() {
        guard isEditing, !isDeleting else { return }
        Task { await deletePayment() }
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
private extension PaymentMethodFormViewModel {
    func save() async {
        isSaving = true
        errorMessage = nil
        do {
            switch mode {
            case .add:
                try await service.addPaymentMethod(form)
            case .edit(let method):
                try await service.updatePaymentMethod(id: method.id, form: form)
            }
            isSaving = false
            didSave = true
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
    
    func deletePayment() async {
        guard case .edit(let method) = mode else { return }
        isDeleting = true
        errorMessage = nil
        do {
            try await service.deletePaymentMethod(id: method.id)
            isDeleting = false
            showsRemoveConfirmation = false
            didDelete = true
        } catch {
            isDeleting = false
            errorMessage = error.localizedDescription
        }
    }
}
