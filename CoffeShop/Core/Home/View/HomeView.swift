//
//  HomeView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment:.bottom) {
                ScrollView {
                    HomeHeaderView()
                        .frame(maxWidth: .infinity)
                }
            }
            .background(Color.init(hex: "#313131"))
        }
        .ignoresSafeArea()
        .background(Color.init(hex: "#313131"))
    }
}

#Preview {
    HomeView()
}
