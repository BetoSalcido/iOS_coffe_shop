//
//  PaymentMethodsView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var viewModel: PaymentMethodsViewModel

    private let paymentMethodsService: any PaymentMethodsProviding
    
    init(paymentMethodsService: any PaymentMethodsProviding) {
        self.paymentMethodsService = paymentMethodsService
        
        _viewModel = State(
            wrappedValue: PaymentMethodsViewModel(
                service: paymentMethodsService
            )
        )
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel

        Group {
            switch viewModel.loadState {
            case .loading:
                InlineLoadingView(message: "Loading PaymentMethods…")
            case .failed(let message), .refreshFailed(let message):
                InlineErrorView(
                    title: "Couldn't payment methods",
                    message: message,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            case .refreshing where viewModel.paymentMethods.isEmpty:
                InlineLoadingView(message: "Loading PaymentMethods…")
            case .loaded where viewModel.paymentMethods.isEmpty:
                PaymentMethodEmptyStateView {
                    viewModel.handleAddPaymentMethod()
                }
            case .refreshing, .loaded:
                detailContent(viewModel.paymentMethods)
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
        .navigationDestination(item: $viewModel.formRoute) { mode in
            PaymentMethodFormView(
                paymentMethodsService: paymentMethodsService,
                mode: mode
            )
            .id(mode)
        }
        .onChange(of: viewModel.formRoute) { _, route in
            if route == nil {
                viewModel.handleRefresh()
            }
        }
    }
    
    @ViewBuilder
    private func detailContent(_ paymentMethods: [PaymentMethod]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                PaymentMethodHeaderView()
                
                Text("Tus Tarjetas")
                    .font(.headline)
                
                ForEach(paymentMethods) { item in
                    PaymentMethodItem(paymentMethod: item) {
                        viewModel.handleSelectDefault(item)
                    } onTapEdit: {
                        viewModel.handleEditPaymentMethod(item)
                    }

                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "#F9F9F9"))
        .safeAreaInset(edge: .bottom) {
            PaymentMethodFooterView(onTap: {
                viewModel.handleAddPaymentMethod()
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: "#F9F9F9"))
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodsView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
}

/// Design canvas — sample list content before the real list UI is wired.
#Preview("Sample cards") {
    List(DeveloperPreview().paymentMethods) { method in
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(method.displayName)
                    .font(.headline)
                Text(method.cardholderName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Exp \(method.formattedExpiration)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if method.isDefault {
                Text("Default")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 4)
    }
    .navigationTitle("Payment Methods")
}

#Preview("Empty state") {
    ContentUnavailableView(
        "No payment methods",
        systemImage: "creditcard",
        description: Text("Add a card to pay for your coffee faster.")
    )
}
