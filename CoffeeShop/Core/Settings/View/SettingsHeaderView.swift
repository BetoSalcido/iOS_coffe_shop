//
//  SettingsHeaderView.swift
//  CoffeeShop
//

import SwiftUI

struct SettingsHeaderView: View {
    
    let isUserPro: Bool
    
    var body: some View {
        VStack {
            Image(isUserPro ? "UserProIcon" : "UserIcon")
                .resizable()
                .frame(width: 96, height: 96)
            
            Text("Alex Rodriguez")
                .font(.headline)
                .foregroundStyle(.black)
            
            if isUserPro {
                HStack {
                    Image("ProIcon")
                        .resizable()
                        .frame(width: 11, height: 11)
                    
                    Text("Gold Member")
                        .font(.caption)
                        .foregroundStyle(Color.Tag.primary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.Tag.primaryBackgtound)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 16)
        .background(Color.Background.item)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview("Pro") {
    SettingsHeaderView(isUserPro: true)
        .padding()
}

#Preview("Free") {
    SettingsHeaderView(isUserPro: false)
        .padding()
}
