//
//  LoginViewModel.swift
//  CoffeeShop
//

import Foundation
import Observation

@Observable @MainActor
final class LoginViewModel {

    private let service: any AuthProviding

    init(service: any AuthProviding) {
        self.service = service
    }
}
