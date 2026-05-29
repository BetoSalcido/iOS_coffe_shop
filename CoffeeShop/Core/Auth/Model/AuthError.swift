//
//  AuthError.swift
//  CoffeeShop
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case invalidEmail
    case missingName
    case passwordMismatch
    case emailConfirmationRequired
    case socialSignInNotSupported
    case server(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Please enter your email and password."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .missingName:
            return "Please enter your name."
        case .passwordMismatch:
            return "Passwords do not match."
        case .emailConfirmationRequired:
            return "Check your email to confirm your account before signing in."
        case .socialSignInNotSupported:
            return "Social sign-in is not available yet."
        case .server(let message):
            return message
        }
    }
}
