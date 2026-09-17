//
//  AddPaymentMethodView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/07/26.
//

import SwiftUI

struct AddPaymentMethodView: View {
    private let paymentMethodsService: any PaymentMethodsProviding
    @State private var viewModel: AddPaymentMethodViewModel

    init(paymentMethodsService: any PaymentMethodsProviding) {
        self.paymentMethodsService = paymentMethodsService
        _viewModel = State(
            wrappedValue: AddPaymentMethodViewModel(service: paymentMethodsService)
        )
    }

    var body: some View {
        Text("Add Payment Method")
            .navigationTitle("Add Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        AddPaymentMethodView(paymentMethodsService: AppServiceProvider.live.paymentMethods)
    }
}

/// Design canvas — filled form values for AddPaymentMethodView layout.
#Preview("Filled form data") {
    let form = DeveloperPreview().filledNewPaymentMethodForm
    Form {
        LabeledContent("Name", value: form.cardholderName)
        LabeledContent("Number", value: form.cardNumber)
        LabeledContent("Brand", value: form.inferredBrand.displayName)
        LabeledContent("Expiry", value: "\(form.expirationMonth)/\(form.expirationYear)")
        LabeledContent("CVV", value: form.cvv)
        LabeledContent("Default", value: form.setAsDefault ? "Yes" : "No")
        LabeledContent("Last4", value: form.last4)
    }
    .navigationTitle("Add Payment Method")
}
