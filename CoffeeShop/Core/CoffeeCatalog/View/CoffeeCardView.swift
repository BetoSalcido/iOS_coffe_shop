//
//  CoffeeCardView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 14/10/25.
//

import SwiftUI

struct CoffeeCardView: View {
    let coffee: Coffee
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                Image(coffee.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 128)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(alignment: .topTrailing) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").font(.caption2)
                            Text(String(format: "%.1f", coffee.rating)).font(.caption2).bold()
                        }
                        .padding(6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(8)
                    }

                Text(coffee.name)
                    .font(.headline)

                Text(coffee.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack {
                    Text(coffee.formattedPrice)
                        .font(.title3)
                        .bold()

                    Spacer()

                    Button {
                        print("Add Coffee!")
                    } label: {
                        Image("AddIcon")
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(radius: 2, y: 1)
        }
        .buttonStyle(.plain) // evita el efecto de botón azul por defecto
    }
}


#Preview {
    CoffeeCardView(coffee: DeveloperPreview().coffees[0], onTap: {
        print("Coffee tapped")
    })
}
