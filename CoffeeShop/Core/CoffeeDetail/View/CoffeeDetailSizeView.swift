//
//  CoffeeDetailSizeView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailSizeView: View {

    let name: String
    let isActive: Bool
    let onTap: () -> Void

    init(size: CoffeeSize, onTap: @escaping () -> Void) {
        self.name = size.name
        self.isActive = size.isActive
        self.onTap = onTap
    }

    init(modifier: CoffeeModifier, onTap: @escaping () -> Void) {
        self.name = modifier.name
        self.isActive = modifier.isActive
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            Text(name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? Color.Buttons.active : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .background(isActive ? Color.Buttons.active.opacity(0.2) : Color.Buttons.inactive)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isActive ? Color.Buttons.active : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .shadow(radius: 2, y: 1)
        .buttonStyle(.plain)
    }
}

#Preview {
    CoffeeDetailSizeView(size: CoffeeSize(id: "1", name: "12 oz", isActive: true)) {
        print("Size tapped")
    }
}
