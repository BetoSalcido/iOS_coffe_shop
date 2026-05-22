//
//  Order.swift
//  CoffeeShop
//

import Foundation

struct Order: Identifiable, Hashable {
    let id: String
    let lineItems: [OrderLineItem]
    let deliveryFee: Double

    var subtotal: Double {
        lineItems.reduce(0) { $0 + $1.lineTotal }
    }

    var total: Double {
        subtotal + deliveryFee
    }

    var formattedSubtotal: String {
        String(format: "$%.2f", subtotal)
    }

    var formattedDeliveryFee: String {
        String(format: "$%.2f", deliveryFee)
    }

    var formattedTotal: String {
        String(format: "$%.2f", total)
    }
}
