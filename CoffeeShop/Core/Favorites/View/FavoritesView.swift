//
//  FavoritesView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct FavoritesView: View {
    private let serviceProvider: any ServiceProvider
    @State private var viewModel: FavoritesViewModel

    init(serviceProvider: any ServiceProvider) {
        self.serviceProvider = serviceProvider
        _viewModel = State(
            wrappedValue: FavoritesViewModel(
                favoritesService: serviceProvider.favorites,
                catalogService: serviceProvider.catalog
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            Group {
                if viewModel.isLoading {
                    InlineLoadingView(message: "Loading favorites…")
                } else if viewModel.needsSignIn {
                    InlineErrorView(
                        title: "Sign in required",
                        message: "Log in to save coffees and see your favorites here.",
                        retryTitle: "Refresh",
                        onRetry: { viewModel.handleRetryLoad() }
                    )
                } else if let error = viewModel.loadError {
                    InlineErrorView(
                        title: "Couldn't load favorites",
                        message: error,
                        onRetry: { viewModel.handleRetryLoad() }
                    )
                } else if viewModel.coffees.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        CatalogGridView(coffeeList: viewModel.coffees, isAddButtonVisible: false) { coffee in
                            viewModel.handleCoffeeSelectionWith(coffee)
                        }
                    }
                    .background(.white)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
            .navigationDestination(item: $viewModel.selectedCoffee) { coffee in
                CoffeeDetailView(
                    coffee: coffee,
                    coffeeDetailsService: serviceProvider.coffeeDetails,
                    favoritesService: serviceProvider.favorites,
                    orderService: serviceProvider.order
                )
            }
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
        }
        .refreshable {
            await viewModel.loadFavorites()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No favorites yet")
                .font(.headline)
            Text("Tap the heart on a coffee to save it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    FavoritesView(serviceProvider: AppServiceProvider.live)
}
