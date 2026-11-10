//
//  PaymentMethodForm.swift
//  CoffeeShop
//

import Foundation

/// Mutable form state for adding or editing a card in `PaymentMethodFormView`.
/// Never persist `cardNumber` / `cvv`.
struct PaymentMethodForm {
    var cardholderName = ""
    var cardNumber = ""
    var expirationMonth = ""
    var expirationYear = ""
    var cvv = ""
    var setAsDefault = false
    /// Set only when this form edits a saved card. The PAN and CVV are never stored.
    var editingID: String?
    var savedBrand: CardBrand?
    var savedLast4: String?

    init(
        cardholderName: String = "",
        cardNumber: String = "",
        expirationMonth: String = "",
        expirationYear: String = "",
        cvv: String = "",
        setAsDefault: Bool = false
    ) {
        self.cardholderName = cardholderName
        self.cardNumber = cardNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
        self.setAsDefault = setAsDefault
    }

    /// Name, expiry, and default come from the saved card. The number field stays empty.
    static func editing(_ method: PaymentMethod) -> PaymentMethodForm {
        var form = PaymentMethodForm(
            cardholderName: method.cardholderName,
            expirationMonth: String(format: "%02d", method.expirationMonth),
            expirationYear: String(format: "%02d", method.expirationYear % 100),
            setAsDefault: method.isDefault
        )
        form.editingID = method.id
        form.savedBrand = method.brand
        form.savedLast4 = method.last4
        return form
    }

    var digitsOnlyCardNumber: String {
        cardNumber.filter(\.isNumber)
    }

    var last4: String {
        String(digitsOnlyCardNumber.suffix(4))
    }

    var inferredBrand: CardBrand {
        CardBrand.infer(fromCardNumber: digitsOnlyCardNumber)
    }

    var expirationInput: String {
        if expirationMonth.isEmpty && expirationYear.isEmpty { return "" }
        if expirationYear.isEmpty { return expirationMonth }
        return "\(expirationMonth)/\(expirationYear)"
    }

    /// The typed PAN replaces the saved card. An empty number keeps `brand` + `last4`.
    var keepsSavedCard: Bool {
        savedLast4 != nil && digitsOnlyCardNumber.isEmpty
    }

    var persistedBrand: CardBrand {
        keepsSavedCard ? (savedBrand ?? .unknown) : inferredBrand
    }

    var persistedLast4: String {
        keepsSavedCard ? (savedLast4 ?? "") : last4
    }

    var previewBrandName: String {
        if keepsSavedCard, let savedBrand {
            return savedBrand.displayName.uppercased()
        }
        return digitsOnlyCardNumber.isEmpty ? "VISA" : inferredBrand.displayName.uppercased()
    }

    var previewCardNumber: String {
        if keepsSavedCard, let savedLast4 {
            return "•••• •••• •••• \(savedLast4)"
        }
        let digits = digitsOnlyCardNumber
        guard !digits.isEmpty else { return "•••• •••• •••• ••••" }
        return stride(from: 0, to: digits.count, by: 4).map { offset in
            let start = digits.index(digits.startIndex, offsetBy: offset)
            let end = digits.index(start, offsetBy: min(4, digits.distance(from: start, to: digits.endIndex)))
            return String(digits[start..<end])
        }.joined(separator: " ")
    }

    var previewCardholderName: String {
        let trimmed = cardholderName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "YOUR NAME" : trimmed.uppercased()
    }

    var previewExpiration: String {
        expirationInput.isEmpty ? "MM/YY" : expirationInput
    }

    var trimmedCardholderName: String {
        cardholderName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExpirationYear: Int {
        guard let value = Int(expirationYear.filter(\.isNumber)) else { return 0 }
        return value < CardFormLimit.twoDigitYearBoundary
            ? CardFormLimit.yearCentury + value
            : value
    }

    var expirationMonthNumber: Int {
        Int(expirationMonth) ?? 0
    }

    var isValid: Bool {
        isCardholderNameValid && isCardNumberValid && isExpirationValid && isCVVValid
    }

    var isCardholderNameValid: Bool {
        let name = trimmedCardholderName
        guard !name.isEmpty else { return false }
        return name.allSatisfy { $0.isLetter || $0 == " " }
    }

    var isCardNumberValid: Bool {
        if keepsSavedCard { return true }
        let digits = digitsOnlyCardNumber
        guard digits.allSatisfy(\.isNumber) else { return false }
        guard CardFormLimit.accepts(length: digits.count, for: inferredBrand) else { return false }
        return CardFormLimit.passesLuhn(digits)
    }

    var isExpirationValid: Bool {
        let digits = expirationMonth.filter(\.isNumber) + expirationYear.filter(\.isNumber)
        guard digits.count == CardFormLimit.expirationDigitCount else { return false }
        guard CardFormLimit.expirationMonth.contains(expirationMonthNumber) else { return false }
        return !isExpirationInThePast
    }

    var isCVVValid: Bool {
        if keepsSavedCard { return true }
        return cvv.allSatisfy(\.isNumber) && cvv.count == CardFormLimit.cvvLength(for: inferredBrand)
    }

    func validate() throws {
        guard isCardholderNameValid else { throw PaymentMethodFormError.missingCardholderName }
        guard isCardNumberValid else { throw PaymentMethodFormError.invalidCardNumber }
        guard isExpirationValid else { throw PaymentMethodFormError.invalidExpiration }
        guard isCVVValid else { throw PaymentMethodFormError.invalidCVV }
    }

    /// Letters and spaces only. Drops a leading space, digits, and punctuation.
    mutating func updateCardholderName(_ raw: String) {
        var result = ""
        for character in raw {
            if character.isLetter {
                result.append(character)
            } else if character == " ", !result.isEmpty, result.last != " " {
                result.append(" ")
            }
        }
        cardholderName = result
    }

    /// Digits only, capped at the ISO/IEC 7812 maximum. Spaces are dropped.
    mutating func updateCardNumber(_ raw: String) {
        cardNumber = String(
            raw.filter(\.isNumber).prefix(CardFormLimit.cardNumberLength.upperBound)
        )
    }

    mutating func updateExpiration(_ raw: String) {
        let digits = raw.filter(\.isNumber).prefix(CardFormLimit.expirationDigitCount)
        expirationMonth = String(digits.prefix(2))
        expirationYear = digits.count > 2 ? String(digits.dropFirst(2)) : ""
    }

    mutating func updateCVV(_ raw: String) {
        cvv = String(raw.filter(\.isNumber).prefix(CardFormLimit.amexCVVLength))
    }

    private var isExpirationInThePast: Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let year = normalizedExpirationYear
        if year > currentYear { return false }
        if year == currentYear { return expirationMonthNumber < currentMonth }
        return true
    }
}

enum PaymentMethodFormError: LocalizedError {
    case missingCardholderName
    case invalidCardNumber
    case invalidExpiration
    case invalidCVV

    var errorDescription: String? {
        switch self {
        case .missingCardholderName:
            return "Enter the name on the card."
        case .invalidCardNumber:
            return "Enter a valid card number."
        case .invalidExpiration:
            return "Enter a valid expiration date."
        case .invalidCVV:
            return "Enter a valid CVV."
        }
    }
}
