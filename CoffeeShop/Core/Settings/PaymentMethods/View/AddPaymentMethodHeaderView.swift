//
//  AddPaymentMethodHeaderView.swift
//  CoffeeShop
//

import SwiftUI

struct AddPaymentMethodHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Add Payment Method")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.Text.title)
                .tracking(-0.24)

            Text("Securely save your payment details for a faster checkout ritual.")
                .font(.subheadline)
                .foregroundStyle(Color.Payment.subtitle)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AddPaymentMethodHeaderView()
        .padding()
        .background(Color.Background.appBackground)
}
