//
//  CoffeeCategoryView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import SwiftUI

struct CoffeeCategoryView: View {
    
    let category: CoffeeCategory
    
    var body: some View {
        HStack {
            Text(category.name)
                .font(.footnote)
                .foregroundStyle(category.isActive ? .white : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .background(category.isActive ? Color.init(hex: "#C67C4E") : .white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CoffeeCategoryView(category: CoffeCategoriesPreview().categories.first!)
}
