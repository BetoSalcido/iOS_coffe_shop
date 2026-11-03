//
//  AddPaymentMethodView.swift
//  CoffeeShop
//

import SwiftUI

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddPaymentMethodViewModel

    init(
        paymentMethodsService: any PaymentMethodsProviding,
        form: NewPaymentMethodForm = NewPaymentMethodForm(setAsDefault: true)
    ) {
        _viewModel = State(
            wrappedValue: AddPaymentMethodViewModel(
                service: paymentMethodsService,
                form: form
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AddPaymentMethodHeaderView()
                AddPaymentMethodCardView(form: viewModel.form)
                AddPaymentMethodFormView(viewModel: viewModel)
                AddPaymentMethodSecurityBanner()
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
        AddPaymentMethodView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
}

#Preview("Filled form") {
    NavigationStack {
        AddPaymentMethodView(
            paymentMethodsService: AppServiceProvider.live.paymentMethods,
            form: DeveloperPreview().filledNewPaymentMethodForm
        )
    }
}

#Preview("Dark") {
    NavigationStack {
        AddPaymentMethodView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
    .preferredColorScheme(.dark)
}
