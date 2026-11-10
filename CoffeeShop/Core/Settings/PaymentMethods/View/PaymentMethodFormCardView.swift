//
//  PaymentMethodFormCardView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodFormCardView: View {
    let form: PaymentMethodForm

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image("CardContactlessIcon")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .accessibilityHidden(true)
                Spacer()
                Text(form.previewBrandName)
                    .font(.callout.weight(.bold))
                    .tracking(1.6)
                    .foregroundStyle(.white)
            }

            Spacer(minLength: 12)

            Text(form.previewCardNumber)
                .font(.title3)
                .tracking(2)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            HStack(alignment: .bottom) {
                labeledValue(title: "CARD HOLDER", value: form.previewCardholderName, alignment: .leading)
                Spacer()
                labeledValue(title: "EXPIRES", value: form.previewExpiration, alignment: .trailing)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 192, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
        .accessibilityElement(children: .combine)
    }

    private var cardBackground: some View {
        LinearGradient(
            colors: [Color.Payment.cardStart, Color.Payment.cardEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .topTrailing) {
            Image("CardWatermark")
                .resizable()
                .frame(width: 138, height: 138)
                .offset(x: 16, y: -16)
                .accessibilityHidden(true)
        }
    }

    private func labeledValue(
        title: String,
        value: String,
        alignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .tracking(0.5)
                .foregroundStyle(Color.Payment.cardLabel)
            Text(value)
                .font(.callout)
                .foregroundStyle(.white)
                .lineLimit(1)
        }
    }
}

#Preview("Empty") {
    PaymentMethodFormCardView(form: PaymentMethodForm())
        .padding()
        .background(Color.Background.appBackground)
}

#Preview("Filled") {
    PaymentMethodFormCardView(form: DeveloperPreview().filledPaymentMethodForm)
        .padding()
        .background(Color.Background.appBackground)
}
