//
//  CoffeeDetailBodyView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailBodyView: View {
    let coffee: Coffee
    let onTap: (CoffeeSize) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Description")
                .font(.headline)
            
            Text(coffee.longDescription)
                .font(.footnote)
            
            Text("Size")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(coffee.sizes, id:  \.self) { item in
                    CoffeeDetailSizeView(size: item) {
                        onTap(item)
                    }
                }
            }
        }
        .background(Color.init(hex: "#F9F9F9"))
        .padding()
    }
}

#Preview {
    CoffeeDetailBodyView(coffee: DeveloperPreview().coffees[0]) { _ in
        print("Size tapped!")
    }
}
