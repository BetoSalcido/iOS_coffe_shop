//
//  SettingsView.swift
//  CoffeeShop
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel

    init(service: any SettingsProviding = SettingsService()) {
        _viewModel = State(wrappedValue: SettingsViewModel(service: service))
    }

    var body: some View {
        Text("Settings View")
    }
}

#Preview {
    SettingsView()
}
