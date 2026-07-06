//
//  CoffeeCardView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 14/10/25.
//

import SwiftUI

struct CoffeeCardView: View {
    let coffee: Coffee
    let isAddButtonVisible: Bool
    let onTap: () -> Void

    init(coffee: Coffee, isAddButtonVisible: Bool = true, onTap: @escaping () -> Void) {
        self.coffee = coffee
        self.isAddButtonVisible = isAddButtonVisible
        self.onTap = onTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: CatalogVisualMetrics.CoffeeCard.contentSpacing) {
            RemoteCoffeeImage(
                url: coffee.imageURL,
                height: CatalogVisualMetrics.CoffeeCard.imageHeight,
                cornerRadius: CatalogVisualMetrics.CoffeeCard.imageCornerRadius
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
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            Text(coffee.description)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .layoutPriority(-1)

            HStack {
                Text(coffee.formattedPrice)
                    .font(.title3)
                    .bold()
                    .lineLimit(1)

                Spacer(minLength: 0)

                if (isAddButtonVisible) {
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
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .padding(CatalogVisualMetrics.CoffeeCard.outerPadding)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: CatalogVisualMetrics.CoffeeCard.outerCornerRadius, style: .continuous)
        )
        .shadow(
            radius: CatalogVisualMetrics.CoffeeCard.shadowRadius,
            y: CatalogVisualMetrics.CoffeeCard.shadowYOffset
        )
        .contentShape(
            RoundedRectangle(cornerRadius: CatalogVisualMetrics.CoffeeCard.outerCornerRadius, style: .continuous)
        )
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    CoffeeCardView(coffee: DeveloperPreview().coffees[9], onTap: {
        print("Coffee tapped")
    })
    .frame(width: 170)
    .padding()
}
