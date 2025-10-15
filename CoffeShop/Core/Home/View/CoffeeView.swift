//
//  CoffeeView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 14/10/25.
//

import SwiftUI

struct CoffeeView: View {
    let coffe: Coffee
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 6) {
                Image(coffe.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 128)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(alignment: .topTrailing) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").font(.caption2)
                            Text(String(format: "%.1f", coffe.rating)).font(.caption2).bold()
                        }
                        .padding(6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(8)
                    }
                
                Text(coffe.name)
                    .font(.headline)
                    
                Text(coffe.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                HStack() {
                    Text(coffe.formattedPrice)
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        print("Add Coffee!")
                    } label: {
                        Image("AddIcon")
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            .background(.white)
            .padding(12)
        }
    }
}

#Preview {
    CoffeeView(coffe: DeveloperPreview().coffees[0])
}
