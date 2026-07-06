//
//  CatalogGridView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 15/10/25.
//

import SwiftUI

struct CatalogGridView: View {

    let coffeeList: [Coffee]
    let isAddButtonVisible: Bool
    let onTap: (Coffee) -> Void

    init(
        coffeeList: [Coffee],
        isAddButtonVisible: Bool = true,
        onTap: @escaping (Coffee) -> Void
    ) {
        self.coffeeList = coffeeList
        self.isAddButtonVisible = isAddButtonVisible
        self.onTap = onTap
    }

    private let columns = [
        GridItem(.flexible(), spacing: CatalogVisualMetrics.Grid.spacing),
        GridItem(.flexible(), spacing: CatalogVisualMetrics.Grid.spacing),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: CatalogVisualMetrics.Grid.spacing) {
            ForEach(coffeeList) { coffee in
                CoffeeCardView(coffee: coffee, isAddButtonVisible: isAddButtonVisible) {
                    onTap(coffee)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
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
