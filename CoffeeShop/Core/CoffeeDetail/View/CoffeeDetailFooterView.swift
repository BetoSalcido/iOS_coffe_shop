//
//  CoffeeDetailFooterView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 12/11/25.
//

import SwiftUI

struct CoffeeDetailFooterView: View {
    let coffee: CoffeeDetail
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            VStack {
                Text("Price")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Text(coffee.formattedPrice)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Text.primary)
            }
            
            Spacer()
            
            Button(action: onTap) {
                Text("Buy Now")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(Color.Buttons.active)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .buttonStyle(.plain)
        }
        .frame(maxHeight: 110)
        .padding(.horizontal)
        .background(.white)
    }
}

#Preview {
    CoffeeDetailFooterView(coffee: DeveloperPreview().coffeeDetails[0]) {
        print("Buy Button Tapped!")
    }
 }
