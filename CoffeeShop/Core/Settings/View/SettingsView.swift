//
//  SettingsView.swift
//  CoffeeShop
//

import SwiftUI

struct SettingsView: View {
    private let serviceProvider: any ServiceProvider
    @State private var viewModel: SettingsViewModel

    init(serviceProvider: any ServiceProvider) {
        self.serviceProvider = serviceProvider
        _viewModel = State(wrappedValue: SettingsViewModel(service: serviceProvider))
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
        .sheet(isPresented: $viewModel.showLoginSheet, onDismiss: {
            viewModel.handleLoginSheetDismissed()
        }) {
            LoginView(service: serviceProvider.auth)
        }
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
    }

    private func settingsContent(_ items: [SettingItem]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SettingsHeaderView(viewModel: viewModel)

                Text("Account Settings")
                    .font(.headline)
                    .foregroundStyle(.black)

                VStack(spacing: 12) {
                    ForEach(items) { item in
                        SettingsRowView(item: item) {
                            viewModel.handleSettingSelection(item.id)
                        }
                    }
                    
                    if viewModel.isLoggedIn {
                        logoutSection()
                            .padding(.top, 16)
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
            LoginView(service: serviceProvider.auth)
        }
    }
    
    private func logoutSection() -> some View {
        Button {
            viewModel.handleLogout()
        } label: {
            HStack(spacing: 10) {
                Image("LogoutIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text("Logout")
                    .font(.headline)
                    .foregroundStyle(Color.Text.title)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 60)
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(hex: "#EDE5DC"), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(serviceProvider: AppServiceProvider.live)
    }
}
