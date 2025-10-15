//
//  CoffeeCategoryView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import SwiftUI

struct CoffeeCategoryView: View {
    
    let category: CoffeeCategory
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onTap()
            } label: {
                Text(category.name)
                    .font(.footnote)
                    .foregroundStyle(category.isActive ? .white : .black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
        }
        .background(category.isActive ? Color.Buttons.active : Color.Buttons.inactive)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CoffeeCategoryView(category: DeveloperPreview().categories.first!) {
        print("Category tapped")
    }
}
