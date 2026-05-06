//
//  CoffeeCatalogView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct CoffeeCatalogView: View {
    private let catalogService: any CoffeeCatalogProviding
    @State private var viewModel: CoffeeCatalogViewModel

    init(catalogService: any CoffeeCatalogProviding) {
        self.catalogService = catalogService
        _viewModel = State(wrappedValue: CoffeeCatalogViewModel(service: catalogService))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        CatalogHeaderView()
                        CatalogBannerView()

//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(viewModel.categories, id: \.self) { category in
//                                    CatalogCategoryView(category: category) {
//                                        viewModel.handleCategorySelectionWith(category.id)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.top)
//                        }
//
//                        CatalogGridView(coffeeList: viewModel.coffees) {
//                            viewModel.handleCoffeeSelectionWith($0)
//                        }
                    }
                }
                .background(.white)
                .navigationDestination(item: $viewModel.selectedCoffee) { coffee in
                    NavigationLink(value: coffee) {
                        CoffeeDetailView(coffee: coffee, catalogService: catalogService)
                    }
                }

                GeometryReader { geo in
                    Color.Background.dark
                        .frame(height: geo.safeAreaInsets.top)
                        .ignoresSafeArea(edges: .top)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

#Preview {
    CoffeeCatalogView(catalogService: CoffeeCatalogService())
}
