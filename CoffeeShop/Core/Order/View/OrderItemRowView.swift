//
//  OrderItemRowView.swift
//  CoffeeShop
//

import SwiftUI

struct OrderItemRowView: View {
    let item: OrderLineItem

    var body: some View {
        HStack(spacing: 12) {
            Image(item.coffee.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.coffee.name)
                    .font(.headline)
                    .foregroundStyle(.black)

                Text("\(item.sizeName) · x\(item.quantity)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text(String(format: "$%.2f", item.lineTotal))
                .font(.headline)
                .foregroundStyle(Color.Text.primary)
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 2, y: 1)
    }
}

#Preview {
    OrderItemRowView(
        item: OrderLineItem(
            id: "preview",
            coffee: DeveloperPreview().coffees[0],
            sizeName: "M",
            quantity: 1
        )
    )
    .padding()
}
