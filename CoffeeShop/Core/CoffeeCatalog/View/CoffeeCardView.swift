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
            VStack(alignment: .leading, spacing: CatalogVisualMetrics.CoffeeCard.contentSpacing) {
                Image(coffee.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: CatalogVisualMetrics.CoffeeCard.imageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: CatalogVisualMetrics.CoffeeCard.imageCornerRadius, style: .continuous)
                    )
                    .overlay(alignment: .topTrailing) {
                        HStack(spacing: CatalogVisualMetrics.CoffeeCard.ratingStarIconSpacing) {
                            Image(systemName: "star.fill").font(.caption2)
                            Text(String(format: "%.1f", coffee.rating)).font(.caption2).bold()
                        }
                        .padding(CatalogVisualMetrics.CoffeeCard.ratingBadgePadding)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(CatalogVisualMetrics.CoffeeCard.ratingBadgeOuterPadding)
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
                            .frame(
                                width: CatalogVisualMetrics.CoffeeCard.addButtonSide,
                                height: CatalogVisualMetrics.CoffeeCard.addButtonSide
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(CatalogVisualMetrics.CoffeeCard.outerPadding)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: CatalogVisualMetrics.CoffeeCard.outerCornerRadius, style: .continuous)
            )
            .shadow(
                radius: CatalogVisualMetrics.CoffeeCard.shadowRadius,
                y: CatalogVisualMetrics.CoffeeCard.shadowYOffset
            )
        }
        .buttonStyle(.plain) // evita el efecto de botón azul por defecto
    }
}


#Preview {
    CoffeeCardView(coffee: DeveloperPreview().coffees[0], onTap: {
        print("Coffee tapped")
    })
}
