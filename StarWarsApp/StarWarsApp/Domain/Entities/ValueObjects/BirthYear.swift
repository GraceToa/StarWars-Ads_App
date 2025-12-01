//
//  BirthYear.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// It represents the year of birth in the Star Wars universe.
/// Examples: "19BBY", "57ABY", "unknown"

struct BirthYear: Equatable, Sendable, Hashable  {
    let rawValue: String
    let value: Double
    let era: Era
    
    enum Era: String, Sendable {
        case bby, aby, unknown
    }
    
    init(_ apiValue: String) {
        rawValue = apiValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if rawValue.hasSuffix("BBY"),
           let number = Double(rawValue.replacingOccurrences(of: "BBY", with: "")) {
            era = .bby
            value = -number
        } else if rawValue.hasSuffix("ABY"),
                  let number = Double(rawValue.replacingOccurrences(of: "ABY", with: "")) {
            era = .aby
            value = number
        } else {
            era = .unknown
            value = .infinity
        }
    }
    
    var formatted: String {
        switch era {
        case .bby, .aby:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

extension BirthYear: Comparable {
    static func < (lhs: BirthYear, rhs: BirthYear) -> Bool {
        lhs.value < rhs.value
    }
}
