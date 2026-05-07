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
        GridItem(
            .adaptive(minimum: CatalogVisualMetrics.Grid.columnMinimumWidth),
            spacing: CatalogVisualMetrics.Grid.spacing
        ),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: CatalogVisualMetrics.Grid.spacing) {
                ForEach(coffeeList, id:  \.self) { item in
                    CoffeeCardView(coffee: item, onTap: {
                        onTap(item)
                    })
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: CatalogVisualMetrics.Grid.cellClipCornerRadius, style: .continuous)
                        )
                        .shadow(
                            radius: CatalogVisualMetrics.CoffeeCard.shadowRadius,
                            y: CatalogVisualMetrics.CoffeeCard.shadowYOffset
                        )
                }
            }
            .padding(CatalogVisualMetrics.Grid.outerPadding)
        }
    }
}

#Preview {
    CatalogGridView(coffeeList: DeveloperPreview().coffees) { _ in
        print("Coffee tapped")
    }
}
