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
    @State private var showFavoriteError = false

    private let orderService: any OrderProviding

    init(
        coffee: Coffee,
        coffeeDetailsService: any CoffeeDetailsProviding,
        favoritesService: any FavoritesProviding,
        orderService: any OrderProviding
    ) {
        self.orderService = orderService
        _viewModel = State(
            wrappedValue: CoffeeDetailViewModel(
                service: coffeeDetailsService,
                favoritesService: favoritesService,
                coffee: coffee
            )
        )
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.handleFavoriteSelection()
                        showFavoriteError = viewModel.favoriteActionError != nil
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                }
            }
        }
        .alert(
            "Favorites",
            isPresented: $showFavoriteError,
            actions: {
                Button("OK") {
                    viewModel.clearFavoriteActionError()
                }
            },
            message: {
                Text(viewModel.favoriteActionError ?? "")
            }
        )
    }

    @ViewBuilder
    private func detailContent(_ detail: CoffeeDetail) -> some View {
        ScrollView {
            CoffeeDetailHeaderView(coffee: detail)
            CoffeeDetailBodyView(coffee: detail) { size in
                viewModel.handleCoffeeSizeSelectionWith(size)
            } onModifierTap: { modifier in
                viewModel.handleCoffeeModifierSelectionWith(modifier)
            }
        }
        .background(Color(hex: "#F9F9F9"))
        .safeAreaInset(edge: .bottom) {
            CoffeeDetailFooterView(coffee: detail, onTap: {
                showOrder = true
            })
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeDetailView(
            coffee: DeveloperPreview().coffees[1],
            coffeeDetailsService: AppServiceProvider.live.coffeeDetails,
            favoritesService: AppServiceProvider.live.favorites,
            orderService: AppServiceProvider.live.order
        )
    }
}
