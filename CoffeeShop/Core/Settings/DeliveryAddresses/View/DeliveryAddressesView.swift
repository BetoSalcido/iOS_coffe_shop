//
//  DeliveryAddressesView.swift
//  CoffeeShop
//

import SwiftUI

struct DeliveryAddressesView: View {
    @State private var viewModel = DeliveryAddressesViewModel()

    var body: some View {
        Text("Delivery Addresses")
            .navigationTitle("Delivery Addresses")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        DeliveryAddressesView()
    }
}
