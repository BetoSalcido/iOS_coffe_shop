//
//  CatalogGridView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 15/10/25.
//

import SwiftUI

struct CatalogGridView: View {

    let coffeeList: [Coffee]
    let onTap: (Coffee) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: CatalogVisualMetrics.Grid.spacing),
        GridItem(.flexible(), spacing: CatalogVisualMetrics.Grid.spacing),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: CatalogVisualMetrics.Grid.spacing) {
            ForEach(coffeeList) { coffee in
                CoffeeCardView(coffee: coffee) {
                    onTap(coffee)
                }
            }
        }
        .padding(CatalogVisualMetrics.Grid.outerPadding)
    }
}

#Preview {
    ScrollView {
        CatalogGridView(coffeeList: DeveloperPreview().coffees) { _ in
            print("Coffee tapped")
        }
    }
}
