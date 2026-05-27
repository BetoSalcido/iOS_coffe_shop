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
    var isLoading = true
    var loadError: String?

    init(service: any SettingsProviding) {
        self.service = service
        
        Task {
            await loadSettings()
        }
    }
}

// MARK:  Private Methods
private extension SettingsViewModel {
    
    func loadSettings() async {
        do {
            let result = try await service.getSettingItems()
            settingItems = result
            isLoading = false
            loadError = nil
        } catch {
            isLoading = false
            settingItems = nil
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
}

