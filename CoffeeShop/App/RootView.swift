//
//  RootView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/05/26.
//

import SwiftUI

/// Top-level app flow: splash → login or main (if session exists) → main after sign-in.
struct RootView: View {
    let serviceProvider: any ServiceProvider

    @State private var screen: AppScreen = .splash

    private let splashDuration: Duration = .seconds(3)

    var body: some View {
        Group {
            switch screen {
            case .splash:
                SplashView()
                    .transition(.opacity)

            case .login:
                LoginView(
                    service: serviceProvider.auth,
                    onSignInSuccess: { screen = .main }
                )
                .transition(.opacity)

            case .main:
                MainTabBarView(serviceProvider: serviceProvider)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: screen)
        .task(id: screen) {
            guard screen == .splash else { return }
            try? await Task.sleep(for: splashDuration)
            screen = serviceProvider.auth.isLoggedIn ? .main : .login
        }
    }
}

private enum AppScreen {
    case splash
    case login
    case main
}

#Preview {
    RootView(serviceProvider: AppServiceProvider.live)
}
