//
//  SettingsViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class SettingsViewModel {

    private let service: any SettingsProviding

    init(service: any SettingsProviding) {
        self.service = service
    }
}
