//
//  AppTextField.swift
//  CoffeeShop
//

import SwiftUI

/// Shared text field for names, card details, and any other typed input.
///
/// `sanitize` runs before a keystroke appears. The default keeps the text as
/// typed. Pass a closure when a screen must reject or rewrite input (letters
/// only, a length cap, a formatted expiry). SwiftUI `TextField` still shows
/// the typed character when the bound value does not change. Pass colors from
/// the screen; the defaults are the shared text tokens.
struct AppTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var autocapitalization: UITextAutocapitalizationType = .none
    var textColor: Color = .Text.title
    var tint: Color = .Buttons.active
    var placeholderColor: Color = .Text.secondary
    var sanitize: (String) -> String = { $0 }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.font = .preferredFont(forTextStyle: .callout)
        textField.adjustsFontForContentSizeCategory = true
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartDashesType = .no
        textField.smartQuotesType = .no
        textField.smartInsertDeleteType = .no
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ textField: UITextField, context: Context) {
        context.coordinator.parent = self
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = false
        textField.autocapitalizationType = autocapitalization
        textField.textColor = UIColor(textColor)
        textField.tintColor = UIColor(tint)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(placeholderColor)]
        )
        if textField.text != displayedText {
            textField.text = displayedText
        }
    }

    /// Secure fields show bullets. The binding still holds the real value.
    private var displayedText: String {
        isSecure ? String(repeating: "•", count: text.count) : text
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AppTextField

        init(parent: AppTextField) {
            self.parent = parent
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let current = parent.text
            let proposed = Self.proposedText(current: current, range: range, replacement: string)
            let sanitized = parent.sanitize(proposed)
            guard sanitized != current else { return false }
            parent.text = sanitized
            textField.text = parent.isSecure
                ? String(repeating: "•", count: sanitized.count)
                : sanitized
            let end = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: end, to: end)
            return false
        }

        /// `UITextField` ranges are unreliable for secure entry, so edits are
        /// applied to the bound value. A bad range appends or deletes at the end.
        private static func proposedText(
            current: String,
            range: NSRange,
            replacement: String
        ) -> String {
            let nsCurrent = current as NSString
            guard range.location != NSNotFound,
                  NSMaxRange(range) <= nsCurrent.length,
                  let swiftRange = Range(range, in: current) else {
                return replacement.isEmpty ? String(current.dropLast()) : current + replacement
            }
            return current.replacingCharacters(in: swiftRange, with: replacement)
        }
    }
}

#Preview("Name") {
    struct PreviewWrapper: View {
        @State private var name = ""

        var body: some View {
            AppTextField(
                text: $name,
                placeholder: "Name",
                autocapitalization: .words
            )
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Digits only") {
    struct PreviewWrapper: View {
        @State private var digits = ""

        var body: some View {
            AppTextField(
                text: $digits,
                placeholder: "0000",
                keyboardType: .numberPad,
                sanitize: { String($0.filter(\.isNumber).prefix(4)) }
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
