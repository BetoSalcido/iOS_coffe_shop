//
//  OrderProviding.swift
//  CoffeeShop
//

import Foundation

protocol OrderProviding: AnyObject {
    func fetchCurrentOrder() async throws -> Order
}
