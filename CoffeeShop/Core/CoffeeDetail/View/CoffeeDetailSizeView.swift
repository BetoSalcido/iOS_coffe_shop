//
//  CoffeeDetailSizeView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 03/11/25.
//

import SwiftUI

struct CoffeeDetailSizeView: View {
    
    let size: CoffeeSize
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(size.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(size.isActive ? Color.Buttons.active : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

        }
        .frame(maxWidth: .infinity)
        .background(size.isActive ? Color.Buttons.active.opacity(0.2) : Color.Buttons.inactive)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(size.isActive ? Color.Buttons.active : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .shadow(radius: 2, y: 1)
        .buttonStyle(.plain)
    }
}

#Preview {
    CoffeeDetailSizeView(size: CoffeeSize(id: NSUUID().uuidString, name: "S", isActive: true)) {
        print("Size tapped")
    }
}
