//
//  SignUpHeaderView.swift
//  CoffeeShop
//

import SwiftUI

struct SignUpHeaderView: View {
    var body: some View {
        VStack {
            Image("CreateAccountBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 192)
                .padding(.horizontal)

            Text("Create your account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.Text.title)

            Text("Join us and enjoy your perfect brew.")
                .font(.subheadline)
                .foregroundStyle(Color.Text.title)
        }
    }
}

#Preview {
    SignUpHeaderView()
}
