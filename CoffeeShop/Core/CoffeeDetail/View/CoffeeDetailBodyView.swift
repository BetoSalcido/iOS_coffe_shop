//
//  CoffeeDetailBodyView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailBodyView: View {
    let coffee: CoffeeDetail
    let onSizeTap: (CoffeeSize) -> Void
    let onModifierTap: (CoffeeModifier) -> Void

    private let optionColumns = [
        GridItem(.adaptive(minimum: 96), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Description")
                .font(.headline)
                .foregroundStyle(.black)

            Text(coffee.longDescription)
                .font(.footnote)
                .foregroundStyle(.gray)

            Text("Size")
                .font(.headline)
                .foregroundStyle(.black)

            LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 12) {
                ForEach(coffee.sizes) { size in
                    CoffeeDetailSizeView(size: size) {
                        onSizeTap(size)
                    }
                }
            }

            if !coffee.modifiers.isEmpty {
                Text("Modifiers")
                    .font(.headline)
                    .foregroundStyle(.black)

                LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 12) {
                ForEach(coffee.modifiers) { modifier in
                    CoffeeDetailSizeView(modifier: modifier) {
                        onModifierTap(modifier)
                    }
                }
                }
            }
        }
        .background(Color(hex: "#F9F9F9"))
        .padding()
    }
}

#Preview {
    CoffeeDetailBodyView(
        coffee: DeveloperPreview().coffeeDetails[0],
        onSizeTap: { _ in },
        onModifierTap: { _ in }
    )
}
