//
//  SettingsService.swift
//  CoffeeShop
//

import Foundation

final class SettingsService: SettingsProviding {

    func getSettingItems() async throws -> [SettingItem] {
        SettingItem.settings
    }
}
