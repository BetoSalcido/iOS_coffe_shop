//
//  LoginBodyView.swift
//  CoffeeShop
//

import SwiftUI

struct LoginBodyView: View {
    @Bindable var viewModel: LoginViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            emailSection
            passwordSection

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            loginButton
            orDivider
            socialButtons
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

    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email Address")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)

            IconTextField(
                text: $viewModel.email,
                placeholder: "name@example.com",
                leadingIcon: "MailIcon",
                keyboardType: .emailAddress
            )
        }
    }

    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Password")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)

                Spacer()

                Button("Forgot Password?") {
                    viewModel.handleForgotPasswordTapped()
                }
                .font(.subheadline)
                .foregroundStyle(Color.Buttons.primaryBackground)
            }

            IconTextField(
                text: $viewModel.password,
                placeholder: "••••••••",
                leadingIcon: "PasswordIcon",
                isSecure: !viewModel.isPasswordVisible,
                trailingIcon: viewModel.isPasswordVisible ? "ShowPasswordIcon" : "HidePasswordIcon",
                onTrailingTap: { viewModel.handleTogglePasswordVisibility() }
            )
        }
    }

    private var loginButton: some View {
        Button {
            viewModel.handleLoginTapped()
        } label: {
            ZStack {
                Text("Login")
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

    private var orDivider: some View {
        HStack(spacing: 12) {
            dividerLine
            Text("OR")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.Text.secondary)
            dividerLine
        }
        .padding(.vertical, 4)
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(Color(hex: "#E5E5E5"))
            .frame(height: 1)
    }

    private var socialButtons: some View {
        HStack(spacing: 12) {
            socialButton(title: "Google", icon: { googleIcon }) {
                viewModel.handleGoogleSignInTapped()
            }
            socialButton(title: "iOS Apple", icon: {
                Image(systemName: "apple.logo")
                    .font(.body.weight(.medium))
                    .foregroundStyle(.black)
            }) {
                viewModel.handleAppleSignInTapped()
            }
        }
    }

    private var googleIcon: some View {
        Text("G")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color(hex: "#4285F4"))
    }

    private func socialButton<Icon: View>(
        title: String,
        @ViewBuilder icon: () -> Icon,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon()
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(hex: "#EDE5DC"), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginBodyView(viewModel: LoginViewModel(service: AuthService()))
        .padding()
        .background(Color.Background.appBackground)
}
