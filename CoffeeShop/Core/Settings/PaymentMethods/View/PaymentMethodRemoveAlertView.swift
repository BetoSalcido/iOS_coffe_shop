//
//  PaymentMethodRemoveAlertView.swift
//  CoffeeShop
//

import SwiftUI

/// Centered confirmation. Presented with `.sheet` so the dim covers the navigation bar.
/// Light and dark colors come from `Color.Payment.remove*`.
struct PaymentMethodRemoveAlertView: View {
    let brand: String
    let last4: String
    var isDeleting = false
    var errorMessage: String?
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            scrim
            dialog
                .padding(.horizontal, 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    private var scrim: some View {
        Color.black
            .opacity(colorScheme == .dark ? 0.62 : 0.62)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                if !isDeleting {
                    onCancel()
                }
            }
            .accessibilityHidden(true)
    }

    private var dialog: some View {
        VStack(spacing: 16) {
            iconBadge

            VStack(spacing: 6) {
                Text("¿Eliminar método de pago?")
                    .font(.title3.weight(.bold))
                    .tracking(-0.45)
                    .foregroundStyle(Color.Payment.removeTitle)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(colorScheme == .dark ? .caption : .footnote)
                    .foregroundStyle(Color.Payment.removeBody)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            cardChip

            VStack(spacing: 10) {
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                confirmButton
                cancelButton
            }
            .padding(.top, 4)
        }
        .padding(25)
        .frame(maxWidth: .infinity)
        .background(Color.Payment.removeSurface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.Payment.removeBorder, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.25), radius: 25, y: 16)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }

    private var message: String {
        "¿Estás seguro de que deseas eliminar tu tarjeta \(brand) terminada en \(last4)? Tendrás que volver a ingresar los datos para futuros pedidos."
    }

    private var iconBadge: some View {
        Image(systemName: "trash")
            .font(.system(size: colorScheme == .dark ? 20 : 24, weight: .regular))
            .foregroundStyle(Color.Payment.deleteText)
            .frame(width: 56, height: 56)
            .background(Color.Payment.removeIconFill, in: Circle())
            .overlay {
                Circle()
                    .strokeBorder(Color.Payment.removeIconBorder, lineWidth: 1)
            }
            .accessibilityHidden(true)
    }

    private var cardChip: some View {
        HStack(spacing: 8) {
            Image(systemName: "creditcard")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.Payment.removeChipIcon)
                .accessibilityHidden(true)

            if colorScheme == .dark {
                Text(brand)
                    .font(.system(.caption, design: .monospaced).weight(.bold))
                    .foregroundStyle(Color.Payment.removeChipText)
                Text("•••• \(last4)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(Color.Payment.removeChipMuted)
            } else {
                Text("\(brand) •••• \(last4)")
                    .font(.system(.caption, design: .monospaced).weight(.bold))
                    .foregroundStyle(Color.Payment.removeChipText)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 7)
        .background(Color.Payment.removeChipFill, in: Capsule())
        .overlay {
            Capsule()
                .strokeBorder(Color.Payment.removeChipBorder, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var confirmButton: some View {
        Button(action: onConfirm) {
            HStack(spacing: 8) {
                if isDeleting {
                    ProgressView()
                        .tint(.white)
                } else if colorScheme == .light {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .semibold))
                        .accessibilityHidden(true)
                }

                Text("Sí, eliminar")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.Payment.removeConfirm)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 1, y: 1)
        }
        .buttonStyle(.plain)
        .disabled(isDeleting)
    }

    private var cancelButton: some View {
        Button(action: onCancel) {
            Text("Cancelar")
                .font(.subheadline.weight(colorScheme == .dark ? .regular : .bold))
                .foregroundStyle(Color.Payment.removeCancelText)
                .frame(maxWidth: .infinity)
                .frame(height: 47)
                .background(Color.Payment.removeChipFill)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.Payment.removeChipBorder, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(isDeleting)
    }
}

#Preview("Light") {
    PaymentMethodRemoveAlertView(
        brand: "Visa",
        last4: "4321",
        onConfirm: {},
        onCancel: {}
    )
}

#Preview("Dark") {
    PaymentMethodRemoveAlertView(
        brand: "Visa",
        last4: "4321",
        onConfirm: {},
        onCancel: {}
    )
    .preferredColorScheme(.dark)
}
