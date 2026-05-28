//
//  LoginView.swift
//  CoffeeShop
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: LoginViewModel

    init(service: any AuthProviding) {
        _viewModel = State(wrappedValue: LoginViewModel(service: service))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    LoginHeaderView()
                    LoginBodyView(viewModel: viewModel)
                    LoginFooterView()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.Background.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {   
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
            }
            .blackNavigationBarStyle()
            .onChange(of: viewModel.didSignInSuccessfully) { _, didSignIn in
                if didSignIn {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    LoginView(service: AppServiceProvider.live.auth)
}
