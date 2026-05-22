//
//  OrderSummaryFooterView.swift
//  CoffeeShop
//

import SwiftUI

struct OrderSummaryFooterView: View {
    let order: Order
    let onPlaceOrder: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            summaryRow(title: "Subtotal", value: order.formattedSubtotal)
            summaryRow(title: "Delivery", value: order.formattedDeliveryFee)

            Divider()

            HStack {
                Image("Wallet")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Total")
                    .font(.headline)
                    .foregroundStyle(.black)
                Spacer()
                Text(order.formattedTotal)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Text.primary)
            }

            Button(action: onPlaceOrder) {
                Text("Place Order")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .background(Color.Buttons.active)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .buttonStyle(.plain)
        }
        .padding()
        .background(.white)
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    OrderSummaryFooterView(
        order: Order(
            id: "preview",
            lineItems: [
                OrderLineItem(
                    id: "1",
                    coffee: DeveloperPreview().coffees[0],
                    sizeName: "M",
                    quantity: 1
                ),
            ],
            deliveryFee: 1.50
        ),
        onPlaceOrder: {}
    )
}
