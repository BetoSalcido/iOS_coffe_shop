//
//  LoginHeaderView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 27/05/26.
//

import SwiftUI

struct LoginHeaderView: View {
    var body: some View {
        VStack {
            Image("LoginIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 50)
            
            Text("Welcome back!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.Text.title)
            
            Text("The perfect brew is just a login away.")
                .font(.subheadline)
                .foregroundStyle(Color.Text.title)
        }
    }
}

#Preview {
    LoginHeaderView()
}
