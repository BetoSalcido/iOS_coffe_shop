//
//  HelpCenterView.swift
//  CoffeeShop
//

import SwiftUI

struct HelpCenterView: View {
    @State private var viewModel = HelpCenterViewModel()

    var body: some View {
        Text("Help Center")
            .navigationTitle("Help Center")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
