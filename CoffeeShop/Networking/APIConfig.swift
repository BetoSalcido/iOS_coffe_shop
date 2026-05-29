//
//  APIConfig.swift
//  CoffeeShop
//

import Foundation

extension NetworkingService {

    /// Supabase configuration from `Secrets.plist` in the app bundle (see `Secrets.plist.example`).
    enum APIConfig {

        static let supabaseURL = secretString(for: "SUPABASE_URL")
        static let supabaseAnonKey = secretString(for: "SUPABASE_ANON_KEY")

        static var authBaseURL: String {
            "\(supabaseURL)/auth/v1"
        }

        static var restBaseURL: String {
            "\(supabaseURL)/rest/v1"
        }

        static func applySupabaseHeaders(to request: inout URLRequest, accessToken: String?) {
            request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
            let bearer = accessToken ?? supabaseAnonKey
            request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

        private static func secretString(for key: String) -> String {
            guard let value = secrets[key] as? String else { return "" }
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        private static let secrets: [String: Any] = {
            guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
                  let data = try? Data(contentsOf: url),
                  let plist = try? PropertyListSerialization.propertyList(
                    from: data,
                    format: nil
                  ) as? [String: Any]
            else {
                #if DEBUG
                print("[APIConfig] Missing Secrets.plist. Copy CoffeeShop/Secrets.plist.example → Secrets.plist and add your Supabase URL/key.")
                #endif
                return [:]
            }
            return plist
        }()
    }
}
