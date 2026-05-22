//
//  View+NavigationBarStyle.swift
//  CoffeeShop
//

import SwiftUI

extension View {
    /// Black navigation bar controls (back chevron, bar buttons, inline title).
    func blackNavigationBarStyle() -> some View {
        tint(.black)
            .toolbarColorScheme(.light, for: .navigationBar)
    }
}
