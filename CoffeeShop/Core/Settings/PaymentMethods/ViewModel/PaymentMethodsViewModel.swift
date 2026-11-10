//
//  PaymentMethodsViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class PaymentMethodsViewModel {
    
    enum LoadState: Equatable {
        case loading
        case refreshing
        case failed(String)
        case refreshFailed(String)
        case loaded
    }

    private(set) var paymentMethods: [PaymentMethod] = []
    private(set) var loadState: LoadState = .loading
    var formRoute: PaymentMethodFormMode?
    
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
        loadState = .loading
        await fetchPaymentMethods(isRefresh: false)
    }

    func fetchPaymentMethods(isRefresh: Bool) async {
        if isRefresh {
            loadState = .refreshing
        }

        do {
            let methods = try await service.fetchPaymentMethods()
            paymentMethods = methods
            loadState = .loaded
        } catch {
            if paymentMethods.isEmpty {
                paymentMethods = []
                loadState = isRefresh
                    ? .refreshFailed(error.localizedDescription)
                    : .failed(error.localizedDescription)
            } else {
                loadState = .loaded
            }
        }
    }

    func applyDefaultLocally(id: String) {
        paymentMethods = paymentMethods.map { method in
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

    /// Reloads the list without replacing it with the full-screen loader.
    func handleRefresh() {
        Task {
            await fetchPaymentMethods(isRefresh: true)
        }
    }
    
    func handleAddPaymentMethod() {
        formRoute = .add
    }

    func handleEditPaymentMethod(_ method: PaymentMethod) {
        formRoute = .edit(method)
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
                await fetchPaymentMethods(isRefresh: true)
            }
        }
    }
}
