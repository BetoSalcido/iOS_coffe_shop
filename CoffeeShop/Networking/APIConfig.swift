//
//  APIConfig.swift
//  CoffeeShop
//

import Foundation

extension NetworkingService {

    /// Supabase and REST configuration.
    /// Replace placeholders when the project is created in the Supabase dashboard.
    enum APIConfig {
        /// Project URL, e.g. `https://abcdefgh.supabase.co`
        static let supabaseURL = "https://YOUR_PROJECT_REF.supabase.co"

        /// `anon` public key from Project Settings → API.
        static let supabaseAnonKey = "YOUR_SUPABASE_ANON_KEY"

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
    }
}
