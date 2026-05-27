//
//  OrderHistoryView.swift
//  CoffeeShop
//

import SwiftUI

struct OrderHistoryView: View {
    @State private var viewModel = OrderHistoryViewModel()

    var body: some View {
        Text("Order History")
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        OrderHistoryView()
    }
}
