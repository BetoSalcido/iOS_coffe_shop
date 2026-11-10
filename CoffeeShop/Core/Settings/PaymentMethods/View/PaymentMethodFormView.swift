//
//  PaymentMethodFormView.swift
//  CoffeeShop
//

import SwiftUI

struct PaymentMethodFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PaymentMethodFormViewModel

    init(
        paymentMethodsService: any PaymentMethodsProviding,
        mode: PaymentMethodFormMode = .add,
        form: PaymentMethodForm? = nil
    ) {
        _viewModel = State(
            wrappedValue: PaymentMethodFormViewModel(
                service: paymentMethodsService,
                mode: mode,
                form: form
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PaymentMethodFormHeaderView(
                    title: viewModel.title,
                    subtitle: viewModel.subtitle
                )
                PaymentMethodFormCardView(form: viewModel.form)
                PaymentMethodFormFieldsView(viewModel: viewModel)
                PaymentMethodFormSecurityBanner()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .background(Color.Background.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.Payment.brand)
            }
        }
        .toolbarBackground(Color.Background.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(Color.Payment.brand)
        .onChange(of: viewModel.didSave) { _, didSave in
            if didSave {
                dismiss()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showsRemoveConfirmation, onDismiss: {
            if viewModel.didDelete {
                dismiss()
            }
        }) {
            PaymentMethodRemoveAlertView(
                brand: viewModel.removeBrandName,
                last4: viewModel.removeLast4,
                isDeleting: viewModel.isDeleting,
                errorMessage: viewModel.errorMessage,
                onConfirm: { viewModel.handleConfirmDelete() },
                onCancel: { viewModel.handleCancelDelete() }
            )
            .presentationBackground(.clear)
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(0)
            .interactiveDismissDisabled(viewModel.isDeleting)
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodFormView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
}

#Preview("Filled form") {
    NavigationStack {
        PaymentMethodFormView(
            paymentMethodsService: AppServiceProvider.live.paymentMethods,
            form: DeveloperPreview().filledPaymentMethodForm
        )
    }
}

#Preview("Edit") {
    NavigationStack {
        PaymentMethodFormView(
            paymentMethodsService: AppServiceProvider.live.paymentMethods,
            mode: .edit(DeveloperPreview().paymentMethods[0])
        )
    }
}

#Preview("Dark") {
    NavigationStack {
        PaymentMethodFormView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
    .preferredColorScheme(.dark)
}
