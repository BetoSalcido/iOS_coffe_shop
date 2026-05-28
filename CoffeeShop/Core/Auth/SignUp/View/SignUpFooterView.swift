//
//  SignUpFooterView.swift
//  CoffeeShop
//

import SwiftUI

struct SignUpFooterView: View {
    var onLoginTapped: () -> Void

    var body: some View {
        HStack {
            Text("Already have an account?")
                .font(.subheadline)

            Button(action: onLoginTapped) {
                Text("Login")
                    .font(.subheadline)
                    .foregroundStyle(Color.Text.primary)
            }
        }
    }
}

#Preview {
    SignUpFooterView(onLoginTapped: {})
}
