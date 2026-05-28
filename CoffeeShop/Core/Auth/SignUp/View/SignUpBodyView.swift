//
//  SignUpBodyView.swift
//  CoffeeShop
//

import SwiftUI

struct SignUpBodyView: View {
    @Bindable var viewModel: SignUpViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            nameSection
            emailSection
            passwordSection
            confirmPasswordSection

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            signUpButton
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(hex: "#EDE5DC"), lineWidth: 1)
        }
        .disabled(viewModel.isLoading)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full Name")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)

            IconTextField(
                text: $viewModel.form.name,
                placeholder: "John Doe",
                leadingIcon: "MailIcon"
            )
        }
    }

    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email Address")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)

            IconTextField(
                text: $viewModel.form.email,
                placeholder: "name@example.com",
                leadingIcon: "MailIcon",
                keyboardType: .emailAddress
            )
        }
    }

    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)

            IconTextField(
                text: $viewModel.form.password,
                placeholder: "••••••••",
                leadingIcon: "PasswordIcon",
                isSecure: !viewModel.isPasswordVisible,
                trailingIcon: viewModel.isPasswordVisible ? "ShowPasswordIcon" : "HidePasswordIcon",
                onTrailingTap: { viewModel.handleTogglePasswordVisibility() }
            )
        }
    }

    private var confirmPasswordSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Confirm Password")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)

            IconTextField(
                text: $viewModel.form.confirmPassword,
                placeholder: "••••••••",
                leadingIcon: "PasswordIcon",
                isSecure: !viewModel.isConfirmPasswordVisible,
                trailingIcon: viewModel.isConfirmPasswordVisible ? "ShowPasswordIcon" : "HidePasswordIcon",
                onTrailingTap: { viewModel.handleToggleConfirmPasswordVisibility() }
            )
        }
    }

    private var signUpButton: some View {
        Button {
            viewModel.handleSignUpTapped()
        } label: {
            ZStack {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.Text.primaryButton)
                    .opacity(viewModel.isLoading ? 0 : 1)

                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.Text.primaryButton)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .background(Color.Buttons.primaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.Buttons.primaryBackground.opacity(0.35), radius: 8, y: 4)
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    SignUpBodyView(viewModel: SignUpViewModel(service: AuthService()))
        .padding()
        .background(Color.Background.appBackground)
}
