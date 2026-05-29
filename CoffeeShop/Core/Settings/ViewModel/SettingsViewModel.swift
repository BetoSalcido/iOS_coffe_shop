//
//  SettingsViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class SettingsViewModel {

    private let service: any ServiceProvider
    private let authProvider: any AuthProviding
    private let settingsProvider: any SettingsProviding

    var settingItems: [SettingItem]?
    var selectedRoute: SettingAction?
    var showLoginSheet = false
    var isLoading = true
    var loadError: String?

    init(service: any ServiceProvider) {
        self.service = service
        self.settingsProvider = service.settings
        self.authProvider = service.auth

        Task {
            await loadSettings()
        }
    }
    
    var isLoggedIn: Bool {
        authProvider.isLoggedIn
    }

    var isUserPro: Bool = false

    /// Session loaded from Keychain via `AuthProviding` (not read in the View).
    var currentSession: AuthSession? {
        authProvider.currentSession()
    }

    var displayName: String {
        guard isLoggedIn else { return "User" }
        if let fullName = currentSession?.fullName,
           !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return fullName
        }
        if let email = currentSession?.email,
           let localPart = email.split(separator: "@").first,
           !localPart.isEmpty {
            return String(localPart).capitalized
        }
        return "User"
    }
}

// MARK: - Private Methods
private extension SettingsViewModel {

    func loadSettings() async {
        do {
            let result = try await settingsProvider.getSettingItems()
            settingItems = result.filter { item in
                !(isLoggedIn && item.id == .login)
            }
            isLoading = false
            loadError = nil
        } catch {
            settingItems = nil
            isLoading = false
            loadError = error.localizedDescription
        }
    }
}

// MARK: - Public Methods
extension SettingsViewModel {

    func handleRetryLoad() {
        loadError = nil
        isLoading = true
        Task {
            await loadSettings()
        }
    }

    func handleLoginSheetDismissed() {
        Task {
            await loadSettings()
        }
    }
    
    func handleLogout() {
        try? authProvider.signOut()
        Task {
            await loadSettings()
        }
    }

    func handleSettingSelection(_ action: SettingAction) {
        switch action {
        case .login:
            showLoginSheet = true
        case .editProfile, .paymentMethods, .orderHistory, .deliveryAddresses, .promos, .helpCenter:
            selectedRoute = action
        }
    }
}
