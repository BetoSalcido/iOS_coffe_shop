//
//  SignUpViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class SignUpViewModel {

    var form = SignUpForm()
    var isPasswordVisible = false
    var isConfirmPasswordVisible = false
    var isLoading = false
    var errorMessage: String?
    var didSignUpSuccessfully = false

    private let service: any AuthProviding

    init(service: any AuthProviding) {
        self.service = service
    }
}

// MARK: - Public Methods
extension SignUpViewModel {

    func handleSignUpTapped() {
        Task {
            await signUp()
        }
    }

    func handleTogglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    func handleToggleConfirmPasswordVisibility() {
        isConfirmPasswordVisible.toggle()
    }

    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Private Methods
private extension SignUpViewModel {

    func signUp() async {
        isLoading = true
        errorMessage = nil

        do {
            _ = try await service.signUp(
                name: form.name,
                email: form.email,
                password: form.password,
                confirmPassword: form.confirmPassword
            )
            isLoading = false
            didSignUpSuccessfully = true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
