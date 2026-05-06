//
//  ContentView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 02/10/25.
//

import SwiftUI

struct ContentView: View {
    let catalogService: any CoffeeCatalogProviding
    @State private var showMain: Bool = false

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
    ContentView(catalogService: CoffeeCatalogService())
}
