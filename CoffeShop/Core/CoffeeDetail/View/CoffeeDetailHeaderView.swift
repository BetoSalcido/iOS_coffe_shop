//
//  CoffeeDetailHeaderView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailHeaderView: View {
    
    let coffee: Coffee?
    
    var body: some View {
        Group {
            if let detail = coffee {
                VStack(spacing: 0) {
                    Image("CaffeeMocha")
                        .resizable()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    
                    HStack {
                        Text(detail.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text(detail.description)
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
                        
                        Text(String(format: "%.1f", detail.rating))
                            .font(.caption2)
                            .bold()
                        
                        Spacer()
                    }
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.horizontal)
                            .offset(y: 10),
                        alignment: .bottom
                    )

                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CoffeeDetailHeaderView(coffee: DeveloperPreview().coffees.first)
}
