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
    
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)];
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(coffeeList, id:  \.self) { item in
                    CoffeeCardView(coffee: item, onTap: {
                        onTap(item)
                    })
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 2, y: 1)
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    CatalogGridView(coffeeList: DeveloperPreview().coffees) { _ in
        print("Coffee tapped")
    }
}
