//
//  PaymentMethodFormHeaderView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodFormHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.Text.title)
                .tracking(-0.24)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.Payment.subtitle)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Add") {
    PaymentMethodFormHeaderView(
        title: "Add Payment Method",
        subtitle: "Securely save your payment details for a faster checkout ritual."
    )
    .padding()
    .background(Color.Background.appBackground)
}

#Preview("Edit") {
    PaymentMethodFormHeaderView(
        title: "Edit Payment Method",
        subtitle: "Update the name, expiry, or default card. The full number is not stored."
    )
    .padding()
    .background(Color.Background.appBackground)
}
