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
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        HomeHeaderView()
                        HomeBannerView()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    CoffeeCategoryView(category: category)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                }
                .background(.white)
                
                // Only top safe area gets the color
                GeometryReader { geo in
                    Color.init(hex: "#313131")
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
