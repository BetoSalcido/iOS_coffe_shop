//
//  RootView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/05/26.
//

import SwiftUI

/// Top-level shell: splash first, then the main tab interface.
struct RootView: View {
    let serviceProvider: any ServiceProvider
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                MainTabBarView(serviceProvider: serviceProvider)
            } else {
                SplashView {
                    showMain = true
                }
            }
        }
    }
}

#Preview {
    RootView(serviceProvider: AppServiceProvider.live)
}
