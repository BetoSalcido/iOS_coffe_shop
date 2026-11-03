//
//  AddPaymentMethodFormView.swift
//  CoffeeShop
//

import SwiftUI

struct AddPaymentMethodFormView: View {
    @Bindable var viewModel: AddPaymentMethodViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            field(title: "Cardholder Name") {
                textField(
                    placeholder: "e.g. Julian Roaster",
                    text: cardholderNameBinding,
                    sanitize: sanitizedCardholderName,
                    capitalizesWords: true
                )
            }

            field(title: "Card Number") {
                textField(
                    placeholder: "0000000000000000",
                    text: cardNumberBinding,
                    keyboard: .numberPad,
                    sanitize: sanitizedCardNumber,
                    leading: "CardFieldIcon"
                )
            }

            HStack(alignment: .top, spacing: 16) {
                field(title: "Expiry Date") {
                    textField(
                        placeholder: "MM/YY",
                        text: expirationBinding,
                        keyboard: .numberPad,
                        sanitize: sanitizedExpiration
                    )
                }
                field(title: "CVV") {
                    textField(
                        placeholder: "•••",
                        text: cvvBinding,
                        keyboard: .numberPad,
                        isSecure: true,
                        sanitize: sanitizedCVV,
                        trailing: "CVVHelpIcon"
                    )
                }
            }

            saveToggle

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            addCardButton
        }
    }

    private var cardholderNameBinding: Binding<String> {
        Binding(
            get: { viewModel.form.cardholderName },
            set: { viewModel.handleCardholderNameChanged($0) }
        )
    }

    private var cardNumberBinding: Binding<String> {
        Binding(
            get: { viewModel.form.cardNumber },
            set: { viewModel.handleCardNumberChanged($0) }
        )
    }

    private var expirationBinding: Binding<String> {
        Binding(
            get: { viewModel.form.expirationInput },
            set: { viewModel.handleExpirationChanged($0) }
        )
    }

    private var cvvBinding: Binding<String> {
        Binding(
            get: { viewModel.form.cvv },
            set: { viewModel.handleCVVChanged($0) }
        )
    }

    private func sanitizedCardholderName(_ raw: String) -> String {
        var copy = viewModel.form
        copy.updateCardholderName(raw)
        return copy.cardholderName
    }

    private func sanitizedCardNumber(_ raw: String) -> String {
        var copy = viewModel.form
        copy.updateCardNumber(raw)
        return copy.cardNumber
    }

    private func sanitizedExpiration(_ raw: String) -> String {
        var copy = viewModel.form
        copy.updateExpiration(raw)
        return copy.expirationInput
    }

    private func sanitizedCVV(_ raw: String) -> String {
        var copy = viewModel.form
        copy.updateCVV(raw)
        return copy.cvv
    }

    private var saveToggle: some View {
        Toggle(isOn: $viewModel.form.setAsDefault) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Save for future purchases")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.Text.title)
                Text("Securely stored for 1-click checkout.")
                    .font(.caption)
                    .foregroundStyle(Color.Payment.subtitle)
            }
        }
        .tint(Color.Payment.brand)
        .padding(.horizontal, 17)
        .padding(.vertical, 13)
        .background(Color.Payment.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.Payment.fieldBorder, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var addCardButton: some View {
        Button {
            viewModel.handleAddCard()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image("AddCardIcon")
                        .resizable()
                        .frame(width: 22, height: 18)
                        .accessibilityHidden(true)
                }
                Text("Add Card")
                    .font(.title3.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.Payment.button)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canSubmit)
        .opacity(viewModel.canSubmit ? 1 : 0.45)
    }

    private func field<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.Text.title)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func textField(
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default,
        isSecure: Bool = false,
        sanitize: @escaping (String) -> String,
        capitalizesWords: Bool = false,
        leading: String? = nil,
        trailing: String? = nil
    ) -> some View {
        HStack(spacing: 12) {
            if let leading {
                Image(leading)
                    .resizable()
                    .frame(width: 20, height: 16)
                    .accessibilityHidden(true)
            }

            AppTextField(
                text: text,
                placeholder: placeholder,
                keyboardType: keyboard,
                isSecure: isSecure,
                autocapitalization: capitalizesWords ? .words : .none,
                tint: Color.Payment.brand,
                placeholderColor: Color.Payment.placeholder,
                sanitize: sanitize
            )
            .frame(maxWidth: .infinity, alignment: .leading)

            if let trailing {
                Image(trailing)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 14)
        .background(Color.Payment.fieldFill)
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.Payment.fieldBorder, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
