//
//  OrderSummaryHeaderView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 22/05/26.
//

import SwiftUI

struct OrderSummaryHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Delivery Address")
                .font(.title2)
                .foregroundStyle(.black)
                .fontWeight(.bold)
            
            HStack {
                Text("Calle Everent #123, Culiacán, Sinaloa")
                    .font(.subheadline)
                    .foregroundStyle(.secondaryText)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                }

            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
    OrderSummaryHeaderView()
}
