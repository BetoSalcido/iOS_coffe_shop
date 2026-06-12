//
//  RemoteCoffeeImage.swift
//  CoffeeShop
//

import SwiftUI
import Kingfisher

/// Kingfisher-backed coffee image with shared loading and transition configuration.
struct RemoteCoffeeImage: View {
    let url: URL
    var width: CGFloat?
    var height: CGFloat
    var cornerRadius: CGFloat = 12

    var body: some View {
        KFImage(url)
            .placeholder {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFill()
            .frame(width: width)
            .frame(minWidth: width == nil ? 0 : nil, maxWidth: width == nil ? .infinity : width)
            .frame(height: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview("Catalog card") {
    RemoteCoffeeImage(
        url: DeveloperPreview().coffees[0].imageURL,
        height: CatalogVisualMetrics.CoffeeCard.imageHeight,
        cornerRadius: CatalogVisualMetrics.CoffeeCard.imageCornerRadius
    )
    .frame(width: 170)
    .padding()
}

#Preview("Order row") {
    RemoteCoffeeImage(
        url: DeveloperPreview().coffees[0].imageURL,
        width: 64,
        height: 64
    )
    .padding()
}
