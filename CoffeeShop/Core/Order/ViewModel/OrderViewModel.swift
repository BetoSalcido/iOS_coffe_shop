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

// MARK: Public Methods
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

    func handleIncrementQuantity(for itemId: String) {
        updateQuantity(for: itemId, delta: 1)
    }

    func handleDecrementQuantity(for itemId: String) {
        updateQuantity(for: itemId, delta: -1)
    }
}

// MARK: Private Methods
private extension OrderViewModel {

    func updateQuantity(for itemId: String, delta: Int) {
        guard let order else { return }

        let updatedItems = order.lineItems.compactMap { item -> OrderLineItem? in
            guard item.id == itemId else { return item }
            let newQuantity = item.quantity + delta
            guard newQuantity > 0 else { return nil }
            return OrderLineItem(
                id: item.id,
                coffee: item.coffee,
                sizeName: item.sizeName,
                quantity: newQuantity
            )
        }

        self.order = Order(
            id: order.id,
            lineItems: updatedItems,
            deliveryFee: order.deliveryFee
        )
    }
}
