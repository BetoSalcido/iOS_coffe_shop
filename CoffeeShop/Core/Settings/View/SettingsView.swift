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
        Group {
            if viewModel.isLoading && viewModel.settingItems == nil {
                InlineLoadingView(message: "Loading details…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't load coffee",
                    message: error,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            } else if let settings = viewModel.settingItems {
                settingsContent(settings)
            } else {
                InlineLoadingView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
    }

    private func settingsContent(_ items: [SettingItem]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SettingsHeaderView(isUserPro: true)
                
                Text("Account Settings")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                VStack(spacing: 12) {
                    ForEach(items) { item in
                        SettingsRowView(item: item, onTapped: {})
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(Color.Background.light)
    }
}

#Preview {
    SettingsView()
}
