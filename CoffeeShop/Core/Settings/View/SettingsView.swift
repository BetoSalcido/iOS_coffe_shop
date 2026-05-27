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
        @Bindable var viewModel = viewModel

        Group {
            if viewModel.isLoading && viewModel.settingItems == nil {
                InlineLoadingView(message: "Loading settings…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't load settings",
                    message: error,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            } else if let settings = viewModel.settingItems {
                settingsContent(settings)
            } else {
                InlineLoadingView()
            }
        }
        .navigationDestination(item: $viewModel.selectedRoute) { action in
            destinationView(for: action)
        }
        .sheet(isPresented: $viewModel.showLoginSheet) {
            LoginView()
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
                        SettingsRowView(item: item) {
                            viewModel.handleSettingSelection(item.id)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(Color.Background.light)
    }

    @ViewBuilder
    private func destinationView(for action: SettingAction) -> some View {
        switch action {
        case .editProfile:
            EditProfileView()
        case .paymentMethods:
            PaymentMethodsView()
        case .orderHistory:
            OrderHistoryView()
        case .deliveryAddresses:
            DeliveryAddressesView()
        case .promos:
            PromosView()
        case .helpCenter:
            HelpCenterView()
        case .login:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
