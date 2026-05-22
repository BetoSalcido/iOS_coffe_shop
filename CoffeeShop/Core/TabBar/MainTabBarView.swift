//
//  MainTabBarView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct MainTabBarView: View {
    let catalogService: any CoffeeCatalogProviding
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            CoffeeCatalogView(catalogService: catalogService)
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
                OrderView()
            }
            .tabItem {
                Image("CheckoutIcon")
            }
            .tag(AppTab.order)

            NotificationsView()
                .tabItem {
                    Image("NotificationsIcon")
                }
                .tag(AppTab.notifications)
        }
    }
}

#Preview {
    MainTabBarView(catalogService: CoffeeCatalogService())
}
