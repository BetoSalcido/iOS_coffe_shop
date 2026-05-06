//
//  CoffeeDetailHeaderView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailHeaderView: View {
    
    let coffee: Coffee
    
    var body: some View {
        VStack(spacing: 0) {
            Image("CaffeeMocha")
                .resizable()
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            
            HStack {
                Text(coffee.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            HStack(alignment: .top) {
                Text(coffee.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .offset(y: 5)
                
                Spacer()
                
                Image("FastDelivery")
                    .frame(width: 40, height: 40)
                
                Image("QualityBean")
                    .frame(width: 40, height: 40)
                
                Image("ExtraMilk")
                    .frame(width: 40, height: 40)
            }
            
            HStack {
                Image("Star")
                    .frame(width: 16, height: 16)
                
                Text(String(format: "%.1f", coffee.rating))
                    .font(.caption2)
                    .bold()
                
                Spacer()
            }
            
            Divider()
                .padding()
        }
        .padding(.horizontal)
        .background(Color.init(hex: "#F9F9F9"))
    }
}

#Preview {
    CoffeeDetailHeaderView(coffee: DeveloperPreview().coffees[0])
}
