//
//  Gender.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Normalizes gender values coming from the API.
enum Gender: String, Codable, Sendable, Hashable  {
    case male, female
    case nA = "n/a"
    case unknown

    init(from apiValue: String) {
        switch apiValue.lowercased() {
        case "male": self = .male
        case "female": self = .female
        case "n/a", "na": self = .nA
        default: self = .unknown
        }
    }
}

