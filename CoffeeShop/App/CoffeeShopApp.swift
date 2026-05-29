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
    private let serviceProvider: any ServiceProvider = AppServiceProvider.liveWithSupabase()

    var body: some Scene {
        WindowGroup {
            RootView(serviceProvider: serviceProvider)
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .active:
                        print("App in foreground!")
                    case .background:
                        print("App in background!")
                    case .inactive:
                        print("App inactive!")
                    @unknown default:
                        print("error...")
                    }
                }
        }
    }
}
