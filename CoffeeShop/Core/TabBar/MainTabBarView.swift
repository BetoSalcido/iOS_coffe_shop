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
                .tabItem {
                    Image("HomeIcon")
                }
                .tag(AppTab.home)

            FavoritesView()
                .tabItem {
                    Image("FavoritesIcon")
                }
                .tag(AppTab.favorites)

            NavigationStack {
                OrderView(service: serviceProvider.order)
            }
            .tabItem {
                Image("CheckoutIcon")
            }
            .tag(AppTab.order)

            NavigationStack {
                SettingsView(serviceProvider: serviceProvider)
            }
            .tabItem {
                Image("SettingsIcon")
            }
            .tag(AppTab.settings)
        }
    }
}

#Preview {
    MainTabBarView(serviceProvider: AppServiceProvider.live)
}
