//
//  LoginView.swift
//  CoffeeShop
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: LoginViewModel

    init(service: any AuthProviding = AuthService()) {
        _viewModel = State(wrappedValue: LoginViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            Text("Login")
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                .blackNavigationBarStyle()
        }
    }
}

#Preview {
    LoginView()
}
