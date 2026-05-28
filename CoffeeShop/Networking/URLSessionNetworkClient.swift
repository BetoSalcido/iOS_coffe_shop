//
//  URLSessionNetworkClient.swift
//  CoffeeShop
//

import Foundation

final class URLSessionNetworkClient: NetworkProviding {

    private let urlSession: URLSession
    private let decoder: JSONDecoder
    private let accessTokenProvider: (any AccessTokenProviding)?

    init(
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        accessTokenProvider: (any AccessTokenProviding)? = nil
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.accessTokenProvider = accessTokenProvider
    }

    func request<T: Decodable>(_ type: T.Type, router: any URLRequestConvertible) async throws -> T {
        var request = try router.makeURLRequest()
        NetworkingService.APIConfig.applySupabaseHeaders(
            to: &request,
            accessToken: accessTokenProvider?.accessToken
        )

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw NetworkingService.NetworkError.transportError(underlying: error)
        }

        try validateResponse(data: data, response: response)

        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkingService.NetworkError.decodingFailed(underlying: error)
        }
    }
}

// MARK: - Private Methods
private extension URLSessionNetworkClient {

    func validateResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingService.NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw NetworkingService.NetworkError.httpError(
                statusCode: httpResponse.statusCode,
                body: body
            )
        }
    }
}
