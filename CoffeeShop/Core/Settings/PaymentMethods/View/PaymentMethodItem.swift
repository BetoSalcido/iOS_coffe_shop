//
//  PaymentMethodItem.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/09/26.
//

import SwiftUI

struct PaymentMethodItem: View {
    
    var paymentMethod: PaymentMethod
    
    var paymentMethodImage: Image {
        return switch paymentMethod.brand {
        case .visa:
            Image("VisaIcon")
        case .mastercard:
            Image("MastercardIcon")
        case .amex:
            Image("AmexIcon")
        case .unknown:
            Image("UnknownIcon")
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            paymentMethodImage
                .frame(width: 50, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(paymentMethod.displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Text("Expira: \(paymentMethod.formattedExpiration)")
                    .font(.title3)
                    .foregroundStyle(.gray)
            }
            
            Spacer(minLength: 0)
            
            if paymentMethod.isDefault {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 76)
        .padding(16)
        .background(Color.List.background)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    paymentMethod.isDefault
                        ? Color.List.activeBorder
                        : Color.List.inavtiveBorder,
                    lineWidth: paymentMethod.isDefault ? 1.5 : 1.0
                )
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        PaymentMethodItem(paymentMethod: DeveloperPreview().paymentMethods[0])
        PaymentMethodItem(paymentMethod: DeveloperPreview().paymentMethods[1])
    }
    .padding(.horizontal)
}
