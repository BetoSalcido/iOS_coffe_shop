//
//  OrderItemRowView.swift
//  CoffeeShop
//

import SwiftUI

struct OrderItemRowView: View {
    let item: OrderLineItem
    let showsTopDivider: Bool
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if showsTopDivider {
                Divider()
                    .overlay(Color.gray.opacity(0.25))
            }

            HStack(alignment: .center, spacing: 12) {
                Image(item.coffee.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.coffee.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                    Text(item.sizeName)
                        .font(.subheadline)
                        .foregroundStyle(Color.Text.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                quantityStepper
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#F9F9F9"))
    }

    private var quantityStepper: some View {
        HStack(spacing: 14) {
            stepperButton(systemName: "minus", action: onDecrement)

            Text("\(item.quantity)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .frame(minWidth: 12)

            stepperButton(systemName: "plus", action: onIncrement)
        }
    }

    private func stepperButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 32, height: 32)
                .background(Color.Buttons.inactive)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OrderItemRowView(
        item: OrderLineItem(
            id: "preview",
            coffee: DeveloperPreview().coffees[3],
            sizeName: "Deep Foam",
            quantity: 1
        ),
        showsTopDivider: false,
        onDecrement: {},
        onIncrement: {}
    )
    .padding()
}
