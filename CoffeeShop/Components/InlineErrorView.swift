//
//  InlineErrorView.swift
//  CoffeeShop
//

import SwiftUI

/// Centered error state with optional retry — reuse anywhere async content can fail.
struct InlineErrorView: View {
    var title: String = "Something went wrong"
    var message: String
    var retryTitle: String = "Try again"
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)
                .symbolRenderingMode(.hierarchical)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let onRetry {
                Button(retryTitle, action: onRetry)
                    .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("With retry") {
    InlineErrorView(message: "Could not load coffee.", onRetry: {
        print("retry")
    })
}

#Preview("No retry") {
    InlineErrorView(message: "Network unavailable.", onRetry: nil)
}
