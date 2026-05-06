//
//  RootView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/05/26.
//

import SwiftUI

/// Top-level shell: splash first, then the main tab interface.
struct RootView: View {
    let catalogService: any CoffeeCatalogProviding
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                MainTabBarView(catalogService: catalogService)
            } else {
                SplashView {
                    showMain = true
                }
            }
        }
    }
}

#Preview {
    RootView(catalogService: CoffeeCatalogService())
}
