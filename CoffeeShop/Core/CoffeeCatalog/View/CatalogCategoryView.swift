//
//  CatalogCategoryView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import SwiftUI

struct CatalogCategoryView: View {
    
    let category: CoffeeCategory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(category.name)
                .font(.footnote)
                .foregroundStyle(category.isActive ? .white : .black)
                .padding(.horizontal, CatalogVisualMetrics.CategoryChip.horizontalPadding)
                .padding(.vertical, CatalogVisualMetrics.CategoryChip.verticalPadding)
                .background(category.isActive ? Color.Buttons.active : Color.Buttons.inactive)
                .clipShape(RoundedRectangle(cornerRadius: CatalogVisualMetrics.CategoryChip.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Selected") {
    CatalogCategoryView(
        category: CoffeeCategory(id: "preview", name: "All Coffee", isActive: true),
        onTap: {}
    )
}

#Preview("Unselected") {
    CatalogCategoryView(
        category: CoffeeCategory(id: "preview-2", name: "Latte", isActive: false),
        onTap: {}
    )
}
