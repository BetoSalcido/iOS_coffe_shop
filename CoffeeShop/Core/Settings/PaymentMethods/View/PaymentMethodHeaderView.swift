//
//  PaymentMethodHeaderView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 16/09/26.
//

import SwiftUI

struct PaymentMethodHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("GESTIÓN SEGURA")
                .font(.title3)
                .foregroundStyle(Color.gray)
                .bold()
            
            Text("Administra tus tarjetas guardadas para pedidos más rápidos.")
                .foregroundStyle(Color.gray)
        }
        .padding(30)
        .background(Color.appBackground)
        .cornerRadius(10)
    }
}

#Preview {
    PaymentMethodHeaderView()
}
