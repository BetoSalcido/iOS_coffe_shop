//
//  LoginView.swift
//  CoffeeShop
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: LoginViewModel

    private let onSignInSuccess: (() -> Void)?

    /// - Parameter onSignInSuccess: When set (e.g. from `RootView`), called after login instead of `dismiss()`.
    init(
        service: any AuthProviding,
        onSignInSuccess: (() -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: LoginViewModel(service: service))
        self.onSignInSuccess = onSignInSuccess
    }

    private var isPresentedAsSheet: Bool {
        onSignInSuccess == nil
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
                if isPresentedAsSheet {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundStyle(.black)
                    }
                }
            }
            .blackNavigationBarStyle()
            .onChange(of: viewModel.didSignInSuccessfully) { _, didSignIn in
                guard didSignIn else { return }
                if let onSignInSuccess {
                    onSignInSuccess()
                } else {
                    dismiss()
                }
            }
        }
    }
}

#Preview("Root flow") {
    LoginView(
        service: AppServiceProvider.live.auth,
        onSignInSuccess: {}
    )
}

#Preview("Sheet") {
    LoginView(service: AppServiceProvider.live.auth)
}
