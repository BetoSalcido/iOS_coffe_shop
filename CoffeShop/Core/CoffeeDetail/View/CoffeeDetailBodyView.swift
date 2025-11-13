//
//  CoffeeDetailBodyView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailBodyView: View {
    let coffee: Coffee?
    let onTap: (CoffeeSize) -> Void
    
    var body: some View {
        Group {
            if let detail = coffee {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Description")
                        .font(.headline)
                    
                    Text(detail.longDescription)
                        .font(.footnote)
                    
                    Text("Size")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        ForEach(detail.sizes, id:  \.self) { item in
                            CoffeeDetailSizeView(size: item) {
                                onTap(item)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CoffeeDetailBodyView(coffee: DeveloperPreview().coffees.first) { _ in
        print("Size tapped!")
    }
}
