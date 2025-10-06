//
//  ContentView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 02/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showMain: Bool = false

    var body: some View {
        Group {
            if showMain {
                MainTabBarView()
            } else {
                SplashView {
                    showMain = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
