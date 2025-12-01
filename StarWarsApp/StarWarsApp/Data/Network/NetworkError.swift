//
//  NetworkError.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Represents the most common network errors that can occur when performing HTTP requests.
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case noData
    case offline
    case unknown(Error)
    
    
    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .requestFailed(let code):
            return "Request failed with status code \(code)."
        case .decodingFailed:
            return "Unable to decode the response from the server."
        case .noData:
            return "No data received from the server."
        case .offline:
            return "No internet connection."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
