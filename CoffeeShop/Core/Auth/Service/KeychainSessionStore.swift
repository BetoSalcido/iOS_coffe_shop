//
//  KeychainSessionStore.swift
//  CoffeeShop
//

import Foundation
import Security

/// Stores `AuthSession` in the iOS Keychain (encrypted at rest).
final class KeychainSessionStore: SessionStoring {

    private let service: String
    private let account: String

    init(
        service: String = "com.coffeeshop.auth.session",
        account: String = "currentUser"
    ) {
        self.service = service
        self.account = account
    }

    var isLoggedIn: Bool {
        load() != nil
    }

    func save(_ session: AuthSession) throws {
        let data = try JSONEncoder().encode(session)
        try deleteIfNeeded()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SessionStoreError.unhandledStatus(status)
        }
    }

    func load() -> AuthSession? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound { return nil }
            return nil
        }

        guard let data = item as? Data else { return nil }
        return try? JSONDecoder().decode(AuthSession.self, from: data)
    }

    func clear() throws {
        try deleteIfNeeded()
    }
}

private extension KeychainSessionStore {

    func deleteIfNeeded() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SessionStoreError.unhandledStatus(status)
        }
    }
}

enum SessionStoreError: LocalizedError {
    case unhandledStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .unhandledStatus(let status):
            return "Could not access secure session storage (code \(status))."
        }
    }
}
