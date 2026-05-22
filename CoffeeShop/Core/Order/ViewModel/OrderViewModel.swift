//
//  OrderViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class OrderViewModel {

    var order: Order?
    var isLoading = true
    var loadError: String?

    private let service: any OrderProviding

    init(service: any OrderProviding) {
        self.service = service

        Task {
            await loadOrder()
        }
    }
}

// MARK: Private Methods
private extension OrderViewModel {

    func loadOrder() async {
        do {
            order = try await service.fetchCurrentOrder()
            isLoading = false
            loadError = nil
        } catch {
            order = nil
            isLoading = false
            loadError = error.localizedDescription
        }
    }
}

// MARK: Prublic Methods
extension OrderViewModel {
    
    func handleretryLoad() {
        loadError = nil
        isLoading = true
        Task {
            await loadOrder()
        }
    }

    func handlePlaceOrder() {
        // TODO: Submit order when backend is available
        print("[Order]: Place order tapped")
    }
}
