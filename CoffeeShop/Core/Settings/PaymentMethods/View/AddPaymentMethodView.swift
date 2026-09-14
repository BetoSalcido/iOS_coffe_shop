//
//  AddPaymentMethodView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/07/26.
//

import SwiftUI

struct AddPaymentMethodView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AddPaymentMethodView()
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
