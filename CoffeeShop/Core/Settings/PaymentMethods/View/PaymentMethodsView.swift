//
//  PaymentMethodsView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var viewModel: PaymentMethodsViewModel
    @State private var showAddPaymentMethod = false
    
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
        Group {
            if viewModel.isLoading {
                InlineLoadingView(message: "Loading PaymentMethods…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't payment methods",
                    message: error,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            } else if let paymentMethods = viewModel.paymentMethods{
                if paymentMethods.count > 0 {
                    detailContent(paymentMethods)
                } else{
                    InlineErrorView(
                        title:  "No payment methods",
                        message: "Add a card to pay for your coffee faster.",
                        onRetry: { viewModel.handleRetryLoad() }
                    )
                }

            } else {
                InlineLoadingView()
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
        .navigationDestination(isPresented: $showAddPaymentMethod) {
            AddPaymentMethodView(paymentMethodsService: paymentMethodsService)
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
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "#F9F9F9"))
        .safeAreaInset(edge: .bottom) {
            PaymentMethodFooterView(onTap: {
                showAddPaymentMethod = true
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
