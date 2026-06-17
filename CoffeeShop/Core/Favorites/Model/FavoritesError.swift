//
//  FavoritesError.swift
//  CoffeeShop
//

import Foundation

enum FavoritesError: LocalizedError {
    case notAuthenticated

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Sign in to save favorites."
        }
    }
}
