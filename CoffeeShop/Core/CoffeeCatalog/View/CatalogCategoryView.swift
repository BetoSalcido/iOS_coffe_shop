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
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(category.isActive ? Color.Buttons.active : Color.Buttons.inactive)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
