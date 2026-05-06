//
//  CoffeeShopApp.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 02/10/25.
//

import SwiftUI

@main
struct CoffeeShopApp: App {
    @Environment(\.scenePhase) private var scenePhase // Para estar altanto de los cambios del scene
    private let catalogService: any CoffeeCatalogProviding = CoffeeCatalogService()

    var body: some Scene {
        WindowGroup {
            ContentView(catalogService: catalogService)
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .active:
                        print("App in foreground!")
                    case .background:
                        print("App in background!")
                    case .inactive:
                        print("App inactive!") // multitarea o inativo
                    @unknown default:
                        print("error...")
                    }
                }
        }
    }
}
