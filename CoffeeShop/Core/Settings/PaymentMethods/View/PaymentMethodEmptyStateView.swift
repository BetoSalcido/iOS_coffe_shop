//
//  PaymentMethodEmptyStateView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 05/11/26.
//

import SwiftUI

struct PaymentMethodEmptyStateView: View {
    
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image("PaymentMethodEmptyStateIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
            
            Text("No hay métodos de pago")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.Text.title)
            
            Text("Guarda tus tarjetas para un pago más rápido y seguro en tus pedidos")
                .font(.subheadline)
                .foregroundStyle(Color.Payment.subtitle)
            
            Button {
                onTap()
            } label: {
                Text("+ Agregar Método de pago")
                    .foregroundStyle(Color.Payment.emptyStateButtonTitlte)
            }
            .frame(height: 48)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background(Color.Payment.button)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(
            Color.Background.appBackground,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .shadow(color: .black.opacity(0.35), radius: 8, y: 4)
    }
}

#Preview {
    PaymentMethodEmptyStateView(onTap: {
        print("Agregar Método de Pago")
    })
}
