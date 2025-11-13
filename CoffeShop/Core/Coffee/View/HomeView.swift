//
//  HomeView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel(service: HomeService())
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        HomeHeaderView()
                        HomeBannerView()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    CoffeeCategoryView(category: category) {
                                        viewModel.handleCategorySelecionWith(category.id)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        
                        CoffeeGridView(coffeeList: viewModel.coffees) {
                            viewModel.handleCoffeSelecionWith($0)
                        }
                    }
                }
                .background(.white)
                .navigationDestination(item: $viewModel.selectedCoffee) { coffee in
                    NavigationLink(value: coffee) {
                        CoffeeDetailView(coffee: coffee)
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
    HomeView()
}
