//
//  SettingItem.swift
//  CoffeeShop
//

import Foundation

enum SettingAction: Hashable {
    case editProfile
    case paymentMethods
    case orderHistory
    case deliveryAddresses
    case promos
    case helpCenter
    case login
}

struct SettingItem: Identifiable {
    let id: SettingAction
    let title: String
    let imageName: String
}

extension SettingItem {

    static let settings: [SettingItem] = [
        .init(id: .editProfile, title: "Edit Profile", imageName: "EditProfileIcon"),
        .init(id: .paymentMethods, title: "Payment Methods", imageName: "PaymentMethodsIcon"),
        .init(id: .orderHistory, title: "Order History", imageName: "OrderHistoryIcon"),
        .init(id: .deliveryAddresses, title: "Delivery Addresses", imageName: "DeliveryAddressIcon"),
        .init(id: .promos, title: "Promos & Coupons", imageName: "PromosIcon"),
        .init(id: .helpCenter, title: "Help Center", imageName: "HelpCenterIcon"),
        .init(id: .login, title: "Login", imageName: "LoginIcon"),
    ]
}
