//
//  PaymentMethodFooterView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 16/09/26.
//

import SwiftUI

struct PaymentMethodFooterView: View {
    
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .fontWeight(.bold)
            
            Text("Agregar Nuevo Método")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(Color.Buttons.active)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .buttonStyle(.plain)
        
    }
}

#Preview {
    PaymentMethodFooterView(onTap: {})
}
