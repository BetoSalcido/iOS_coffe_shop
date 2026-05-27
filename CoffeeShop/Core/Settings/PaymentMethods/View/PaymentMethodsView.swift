//
//  PaymentMethodsView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var viewModel = PaymentMethodsViewModel()

    var body: some View {
        Text("Payment Methods")
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        PaymentMethodsView()
    }
}
