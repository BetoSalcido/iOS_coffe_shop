//
//  IconTextField.swift
//  CoffeeShop
//

import SwiftUI

/// Text field with leading icon, optional secure entry, and optional trailing action icon.
struct IconTextField: View {
    @Binding var text: String
    let placeholder: String
    let leadingIcon: String
    var isSecure: Bool = false
    var trailingIcon: String?
    var keyboardType: UIKeyboardType = .default
    var onTrailingTap: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Image(leadingIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .keyboardType(keyboardType)
                        .autocorrectionDisabled()
                }
            }
            .font(.subheadline)
            .foregroundStyle(.black)

            if let trailingIcon {
                Button(action: { onTrailingTap?() }) {
                    Image(trailingIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(Color(hex: "#F5F5F5"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(hex: "#EDE5DC"), lineWidth: 1)
        }
    }
}

#Preview("Email") {
    struct PreviewWrapper: View {
        @State private var email = ""
        var body: some View {
            IconTextField(
                text: $email,
                placeholder: "name@example.com",
                leadingIcon: "MailIcon",
                keyboardType: .emailAddress
            )
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Password") {
    struct PreviewWrapper: View {
        @State private var password = ""
        var body: some View {
            IconTextField(
                text: $password,
                placeholder: "Password",
                leadingIcon: "PasswordIcon",
                isSecure: true,
                trailingIcon: "HidePasswordIcon"
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
