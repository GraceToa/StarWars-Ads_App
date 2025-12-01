//
//  HTTPClient.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the required interface for a generic HTTP client.
protocol HTTPClientProtocol: Sendable {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public API
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        // TODO: Replace with actual reachability check if needed
        guard let reachable = try? await checkConnection(), reachable else {
            throw NetworkError.offline
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            try validate(response: response)
            return try decode(data: data, as: type)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Private Helpers
    /// Validates the HTTP response and status code.
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed(statusCode: -1)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
    
    /// Attempts to decode the provided Data into the specified Decodable type.
    private func decode<T: Decodable>(data: Data, as type: T.Type) throws -> T {
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    /// Placeholder for future connectivity checks.
    private func checkConnection() async throws -> Bool {
        // TODO: Integrate with NWPathMonitor for actual offline detection.
        return true
    }
}
