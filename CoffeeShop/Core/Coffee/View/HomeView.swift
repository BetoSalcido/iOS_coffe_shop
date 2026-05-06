//
//  HomeView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct HomeView: View {
    private let catalogService: any CoffeeCatalogProviding
    @State private var viewModel: HomeViewModel

    init(catalogService: any CoffeeCatalogProviding) {
        self.catalogService = catalogService
        _viewModel = State(wrappedValue: HomeViewModel(service: catalogService))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        HomeHeaderView()
                        HomeBannerView()
                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(viewModel.categories, id: \.self) { category in
//                                    CoffeeCategoryView(category: category) {
//                                        viewModel.handleCategorySelectionWith(category.id)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.top)
//                        }
//                        
//                        CoffeeGridView(coffeeList: viewModel.coffees) {
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
                
                // Only top safe area gets the color
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
    HomeView(catalogService: CoffeeCatalogService())
}
