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
        form: PaymentMethodForm = PaymentMethodForm(setAsDefault: true)
    ) {
        _viewModel = State(
            wrappedValue: PaymentMethodFormViewModel(
                service: paymentMethodsService,
                form: form
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                PaymentMethodFormHeaderView()
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
                Text("Add Payment Method")
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

#Preview("Dark") {
    NavigationStack {
        PaymentMethodFormView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
    .preferredColorScheme(.dark)
}
