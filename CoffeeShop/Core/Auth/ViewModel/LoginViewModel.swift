//
//  LoginViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class LoginViewModel {

    var email = ""
    var password = ""
    var isPasswordVisible = false
    var isLoading = false
    var errorMessage: String?
    var didSignInSuccessfully = false

    private let service: any AuthProviding

    init(service: any AuthProviding) {
        self.service = service
    }
}

// MARK: - Public Methods
extension LoginViewModel {

    func handleLoginTapped() {
        Task {
            await signIn()
        }
    }

    func handleForgotPasswordTapped() {
        // TODO: Navigate to forgot-password flow
        print("[Auth]: Forgot password tapped")
    }

    func handleTogglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    func handleGoogleSignInTapped() {
        Task {
            await signInWithGoogle()
        }
    }

    func handleAppleSignInTapped() {
        Task {
            await signInWithApple()
        }
    }

    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Private Methods
private extension LoginViewModel {

    func signIn() async {
        isLoading = true
        errorMessage = nil

        do {
            _ = try await service.signIn(email: email, password: password)
            isLoading = false
            didSignInSuccessfully = true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func signInWithGoogle() async {
        await performSocialSignIn { try await service.signInWithGoogle() }
    }

    func signInWithApple() async {
        await performSocialSignIn { try await service.signInWithApple() }
    }

    func performSocialSignIn(_ action: () async throws -> AuthSession) async {
        isLoading = true
        errorMessage = nil

        do {
            _ = try await action()
            isLoading = false
            didSignInSuccessfully = true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
