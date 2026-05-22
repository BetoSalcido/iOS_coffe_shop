//
//  OrderLineItem.swift
//  CoffeeShop
//

import Foundation

struct OrderLineItem: Identifiable, Hashable {
    let id: String
    let coffee: Coffee
    let sizeName: String
    let quantity: Int

    var lineTotal: Double {
        coffee.price * Double(quantity)
    }
}
