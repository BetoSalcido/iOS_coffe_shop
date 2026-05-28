//
//  URLRequestConvertible.swift
//  CoffeeShop
//

import Foundation

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest
}
