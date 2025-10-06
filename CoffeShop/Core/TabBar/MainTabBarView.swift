//
//  MainTabBarView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct MainTabBarView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image("HomeIcon")
                }
                .tag("Home")
            
            FavoritesView()
                .tabItem {
                    Image("FavoritesIcon")
                }
                .tag("Favorites")
            
            CheckoutView()
                .tabItem {
                    Image("CheckoutIcon")
                }
                .tag("Checkout")
            
            NotificationsView()
                .tabItem {
                    Image("NotificationsIcon")
                }
                .tag("Notifications")
        }
    }
}

#Preview {
    MainTabBarView()
}
