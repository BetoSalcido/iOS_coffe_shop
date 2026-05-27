//
//  SettingItem.swift
//  CoffeeShop
//

import Foundation

struct SettingItem: Identifiable {
    let id: String
    let title: String
    let imageName: String
}

extension SettingItem {
    
    static let settings: [SettingItem] = [
        .init(id: UUID().uuidString, title: "Edit Profile", imageName: "EditProfileIcon"),
        .init(id: UUID().uuidString, title: "Payment Methods", imageName: "PaymentMethodsIcon"),
        .init(id: UUID().uuidString, title: "Order History", imageName: "OrderHistoryIcon"),
        .init(id: UUID().uuidString, title: "Delivery Addresses", imageName: "DeliveryAddressIcon"),
        .init(id: UUID().uuidString, title: "Promos & Coupons", imageName: "PromosIcon"),
        .init(id: UUID().uuidString, title: "Help Center", imageName: "HelpCenterIcon"),
        .init(id: UUID().uuidString, title: "Login", imageName: "LoginIcon"),
        
    ]
}
