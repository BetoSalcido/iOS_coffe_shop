//
//  InlineLoadingView.swift
//  CoffeeShop
//

import SwiftUI

/// Centered loading indicator for embedding inside navigation stacks, sheets, or feature containers.
struct InlineLoadingView: View {
    var message: String?

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("Default") {
    InlineLoadingView()
}

#Preview("With message") {
    InlineLoadingView(message: "Loading details…")
}
