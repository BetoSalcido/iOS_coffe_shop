//
//  LoginFooterView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 27/05/26.
//

import SwiftUI

struct LoginFooterView: View {
    var body: some View {
        HStack {
            Text("Dont' have an acount?")
                .font(.subheadline)
            
            Button {
                // Nothing to do yet
            } label: {
                Text("Sign up")
                    .font(.subheadline)
                    .foregroundStyle(Color.Text.primary)
            }

        }
    }
}

#Preview {
    LoginFooterView()
}
