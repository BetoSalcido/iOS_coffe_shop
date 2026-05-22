//
//  OrderService.swift
//  CoffeeShop
//

import Foundation

final class OrderService: OrderProviding {

    func fetchCurrentOrder() async throws -> Order {
        let coffees = DeveloperPreview().coffees
        let lineItems: [OrderLineItem] = [
            OrderLineItem(
                id: UUID().uuidString,
                coffee: coffees[3],
                sizeName: "Deep Foam",
                quantity: 1
            ),
            OrderLineItem(
                id: UUID().uuidString,
                coffee: coffees[1],
                sizeName: "Medium",
                quantity: 2
            ),
        ]

        return Order(
            id: UUID().uuidString,
            lineItems: lineItems,
            deliveryFee: 1.50
        )
    }
}
