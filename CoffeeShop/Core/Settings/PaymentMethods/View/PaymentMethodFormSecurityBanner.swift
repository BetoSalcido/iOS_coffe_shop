//
//  PaymentMethodFormSecurityBanner.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodFormSecurityBanner: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image("PaymentLockIcon")
                .resizable()
                .frame(width: 16, height: 23)
                .accessibilityHidden(true)

            Text("Your payment data is encrypted with 256-bit SSL technology. Artisanal Brew does not store your full card details on our local servers.")
                .font(.subheadline)
                .foregroundStyle(Color.Payment.bannerText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Payment.bannerFill)
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.Payment.bannerBorder, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    PaymentMethodFormSecurityBanner()
        .padding()
        .background(Color.Background.appBackground)
}
