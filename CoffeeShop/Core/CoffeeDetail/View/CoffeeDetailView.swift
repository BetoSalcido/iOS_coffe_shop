//
//  CoffeeDetailView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import SwiftUI

struct CoffeeDetailView: View {

    @State private var viewModel: CoffeeDetailViewModel
    @State private var showOrder = false

    private let orderService: any OrderProviding

    init(
        coffee: Coffee,
        catalogService: any CoffeeCatalogProviding,
        orderService: any OrderProviding
    ) {
        self.orderService = orderService
        _viewModel = State(wrappedValue: CoffeeDetailViewModel(service: catalogService, coffee: coffee))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.coffeeDetail == nil {
                InlineLoadingView(message: "Loading details…")
            } else if let error = viewModel.loadError {
                InlineErrorView(
                    title: "Couldn't load coffee",
                    message: error,
                    onRetry: { viewModel.handleRetryLoad() }
                )
            } else if let detail = viewModel.coffeeDetail {
                detailContent(detail)
            } else {
                InlineLoadingView()
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
        .navigationDestination(isPresented: $showOrder) {
            OrderView(service: orderService)
        }
    }

    @ViewBuilder
    private func detailContent(_ detail: Coffee) -> some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                CoffeeDetailHeaderView(coffee: detail)
                CoffeeDetailBodyView(coffee: detail) {
                    viewModel.handleCoffeeSizeSelectionWith($0)
                }
            }
            .background(Color.init(hex: "#F9F9F9"))

            CoffeeDetailFooterView(coffee: detail, onTap: {
                showOrder = true
            })
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeDetailView(
            coffee: DeveloperPreview().coffees[0],
            catalogService: AppServiceProvider.live.catalog,
            orderService: AppServiceProvider.live.order
        )
    }
}
