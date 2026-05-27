//
//  SettingsRowView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 26/05/26.
//

import SwiftUI

struct SettingsRowView: View {
    
    let item: SettingItem
    let onTapped: () -> Void
    
    var body: some View {
        Button(action: onTapped) {
            HStack(spacing: 12) {
                Image(item.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(Color.Text.title)
                
                Spacer()
                
                Image("RightIcon")
                    .resizable()
                    .frame(width: 7.5, height: 12)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(Color.Background.item)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsRowView(item: SettingItem.settings[0], onTapped: {})
        .padding(.horizontal)
}
