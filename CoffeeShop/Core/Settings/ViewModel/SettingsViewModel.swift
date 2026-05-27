//
//  SettingsViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class SettingsViewModel {

    private let service: any SettingsProviding

    var settingItems: [SettingItem]?
    var selectedRoute: SettingAction?
    var showLoginSheet = false
    var isLoading = true
    var loadError: String?

    init(service: any SettingsProviding) {
        self.service = service

        Task {
            await loadSettings()
        }
    }
}

// MARK: - Private Methods
private extension SettingsViewModel {

    func loadSettings() async {
        do {
            settingItems = try await service.getSettingItems()
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

    func handleSettingSelection(_ action: SettingAction) {
        switch action {
        case .login:
            showLoginSheet = true
        case .editProfile, .paymentMethods, .orderHistory, .deliveryAddresses, .promos, .helpCenter:
            selectedRoute = action
        }
    }
}
