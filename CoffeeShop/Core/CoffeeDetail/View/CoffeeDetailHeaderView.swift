//
//  CoffeeDetailHeaderView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailHeaderView: View {
    
    let coffee: CoffeeDetail
    
    var body: some View {
        VStack(spacing: 0) {
            RemoteCoffeeImage(
                url: coffee.imageURL,
                height: 200,
                cornerRadius: 10
            )
            .padding(.vertical)
            
            HStack {
                Text(coffee.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                Spacer()
            }
            
            HStack(alignment: .top) {
                Text(coffee.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
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
                    .foregroundStyle(.black)
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
    CoffeeDetailHeaderView(coffee: DeveloperPreview().coffeeDetails[0])
}
