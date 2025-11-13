//
//  HomeBannerView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import SwiftUI

struct HomeBannerView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Half top
                Color.init(hex: "#313131")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Half bottom
                Color.white
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Imagen del banner superpuesta
            Image("BannerImage")
                .imageScale(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 150)
        .clipped() // Para asegurar que el contenido no se salga del frame
    }
}

#Preview {
    HomeBannerView()
}
