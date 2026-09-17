//
//  CoffeeShopApp.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 02/10/25.
//

import SwiftUI

@main
struct CoffeeShopApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private let serviceProvider: any ServiceProvider = AppServiceProvider.live

    var body: some Scene {
        WindowGroup {
            RootView(serviceProvider: serviceProvider)
                .onChange(of: scenePhase) { _, newValue in
                    guard newValue == .active else { return }
                    Task {
                        try? await serviceProvider.auth.refreshSessionIfNeeded()
                    }
                }
        }
    }
}
