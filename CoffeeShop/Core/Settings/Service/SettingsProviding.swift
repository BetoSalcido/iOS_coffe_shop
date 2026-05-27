//
//  SettingsProviding.swift
//  CoffeeShop
//

import Foundation

protocol SettingsProviding: AnyObject {
    func getSettingItems() async throws -> [SettingItem]
}
