//
//  MainTabBarView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct MainTabBarView: View {
    let serviceProvider: any ServiceProvider
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            CoffeeCatalogView(serviceProvider: serviceProvider)
                .tabItem { tabIcon("HomeIcon", tab: .home) }
                .tag(AppTab.home)
            
            FavoritesView()
                .tabItem { tabIcon("FavoritesIcon", tab: .favorites) }
                .tag(AppTab.favorites)
            
            NavigationStack {
                OrderView(service: serviceProvider.order)
            }
            .tabItem { tabIcon("CheckoutIcon", tab: .order) }
            .tag(AppTab.order)
            
            NavigationStack {
                SettingsView(serviceProvider: serviceProvider)
            }
            .tabItem { tabIcon("SettingsIcon", tab: .settings) }
            .tag(AppTab.settings)
        }
        .tint(Color.TabItem.color)
    }
    
    
    @ViewBuilder
    private func tabIcon(_ name: String, tab: AppTab) -> some View {
        Image(name)
            .renderingMode(.template)
    }
}

#Preview {
    MainTabBarView(serviceProvider: AppServiceProvider.live)
}
