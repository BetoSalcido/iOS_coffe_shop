//
//  AccessTokenProviding.swift
//  CoffeeShop
//

import Foundation

/// Supplies the user access token for authenticated Supabase / REST calls.
protocol AccessTokenProviding: AnyObject {
    var accessToken: String? { get }
}
