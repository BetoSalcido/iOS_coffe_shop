//
//  NetworkProviding.swift
//  CoffeeShop
//

import Foundation

protocol NetworkProviding: AnyObject {
    func request<T: Decodable>(_ type: T.Type, router: any URLRequestConvertible) async throws -> T
}
