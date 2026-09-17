//
//  PaymentMethodsViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class PaymentMethodsViewModel {
    
    private(set) var paymentMethods: [PaymentMethod]?
    private(set) var isLoading = true
    private(set) var loadError: String?
    
    private let service: any PaymentMethodsProviding
    
    init(service:  any PaymentMethodsProviding) {
        self.service = service
        
        Task {
            await load()
        }
    }
}

// MARK: - Private Methos
private extension PaymentMethodsViewModel {
    
    func load() async {
        isLoading = true
        loadError = nil
        await fetchPaymentMethods()
    }
    
    func fetchPaymentMethods() async {
        do {
            let methods = try await service.fetchPaymentMethods()
            print(methods)
            paymentMethods = methods
            isLoading = false
            loadError = nil
        } catch {
            isLoading = false
            paymentMethods = []
            loadError = error.localizedDescription
        }
    }

    func applyDefaultLocally(id: String) {
        paymentMethods = paymentMethods?.map { method in
            var copy = method
            copy.isDefault = method.id == id
            return copy
        }
    }
}

// MARK: Public Methos
extension PaymentMethodsViewModel {
    
    func handleRetryLoad() {
        Task {
            await load()
        }
    }
    
    /// Selects a card as default. Updates UI immediately, then persists via the service.
    func handleSelectDefault(_ method: PaymentMethod) {
        guard method.isDefault == false else { return }
        
        applyDefaultLocally(id: method.id)
        
        Task {
            do {
                try await service.setDefaultPaymentMethod(id: method.id)
            } catch {
                // Re-sync from source of truth if the remote call fails.
                await fetchPaymentMethods()
                loadError = error.localizedDescription
            }
        }
    }
}