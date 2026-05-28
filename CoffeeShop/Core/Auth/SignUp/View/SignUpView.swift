//
//  SignUpView.swift
//  CoffeeShop
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SignUpViewModel

    private let onSignUpSuccess: (() -> Void)?

    /// - Parameter onSignUpSuccess: When set (e.g. from `RootView` via `LoginView`), called after sign-up instead of only popping.
    init(
        service: any AuthProviding,
        onSignUpSuccess: (() -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: SignUpViewModel(service: service))
        self.onSignUpSuccess = onSignUpSuccess
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ScrollView {
            VStack(spacing: 24) {
                SignUpHeaderView()
                SignUpBodyView(viewModel: viewModel)
                SignUpFooterView {
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.Background.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .blackNavigationBarStyle()
        .onChange(of: viewModel.didSignUpSuccessfully) { _, didSignUp in
            guard didSignUp else { return }
            if let onSignUpSuccess {
                onSignUpSuccess()
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView(service: AppServiceProvider.live.auth)
    }
}
