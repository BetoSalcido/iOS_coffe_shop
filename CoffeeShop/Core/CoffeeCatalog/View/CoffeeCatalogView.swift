//
//  CoffeeCatalogView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct CoffeeCatalogView: View {
    private let serviceProvider: any ServiceProvider
    @State private var viewModel: CoffeeCatalogViewModel

    init(serviceProvider: any ServiceProvider) {
        self.serviceProvider = serviceProvider
        _viewModel = State(wrappedValue: CoffeeCatalogViewModel(service: serviceProvider.catalog))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        CatalogTopSection()

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.categories) { category in
                                    CatalogCategoryView(category: category) {
                                        viewModel.handleCategorySelectionWith(category.id)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }

                        CatalogGridView(coffeeList: viewModel.coffees) { coffee in
                            viewModel.handleCoffeeSelectionWith(coffee)
                        }
                    }
                }
                .background(.white)
                .navigationDestination(item: $viewModel.selectedCoffee) { coffee in
                    CoffeeDetailView(
                        coffee: coffee,
                        catalogService: serviceProvider.catalog,
                        orderService: serviceProvider.order
                    )
                }

                GeometryReader { geo in
                    Color.Background.dark
                        .frame(height: geo.safeAreaInsets.top)
                        .ignoresSafeArea(edges: .top)
                        .allowsHitTesting(false)
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    CoffeeCatalogView(serviceProvider: AppServiceProvider.live)
}
