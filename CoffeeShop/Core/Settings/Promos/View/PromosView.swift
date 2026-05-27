//
//  PromosView.swift
//  CoffeeShop
//

import SwiftUI

struct PromosView: View {
    @State private var viewModel = PromosViewModel()

    var body: some View {
        Text("Promos & Coupons")
            .navigationTitle("Promos & Coupons")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        PromosView()
    }
}
