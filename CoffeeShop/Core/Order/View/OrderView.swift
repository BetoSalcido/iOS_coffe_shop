//
//  OrderView.swift
//  CoffeeShop
//

import SwiftUI

struct OrderView: View {
    @State private var viewModel: OrderViewModel

    init(service: any OrderProviding) {
        _viewModel = State(wrappedValue: OrderViewModel(service: service))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.order == nil {
                InlineLoadingView(message: "Loading your order…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't load order",
                    message: error,
                    onRetry: { viewModel.handleretryLoad() }
                )
            } else if let order = viewModel.order {
                orderContent(order)
            } else {
                InlineLoadingView()
            }
        }
        .navigationTitle("Order")
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
    }

    private func orderContent(_ order: Order) -> some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    OrderSummaryHeaderView()

                    VStack(spacing: 0) {
                        ForEach(Array(order.lineItems.enumerated()), id: \.element.id) { index, item in
                            OrderItemRowView(
                                item: item,
                                showsTopDivider: index > 0,
                                onDecrement: { viewModel.handleDecrementQuantity(for: item.id) },
                                onIncrement: { viewModel.handleIncrementQuantity(for: item.id) }
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
                .padding(.bottom, 200)
            }
            .background(Color.init(hex: "#F9F9F9"))

            OrderSummaryFooterView(order: order) {
                viewModel.handlePlaceOrder()
            }
        }
    }
}

#Preview {
    NavigationStack {
        OrderView(service: AppServiceProvider.live.order)
    }
}
