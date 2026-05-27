//
//  SettingsService.swift
//  CoffeeShop
//

import Foundation

final class SettingsService: SettingsProviding {
    
    func getSettingItems() -> [SettingItem] {
        return SettingItem.settings
    }
}
