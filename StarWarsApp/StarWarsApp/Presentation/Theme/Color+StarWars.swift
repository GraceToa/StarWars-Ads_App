//
//  Color+StarWars.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Provides themed background colors for characters based on their role or gender.
extension Color {
    static func starWarsBackground(for gender: Gender) -> LinearGradient {
        switch gender {
        case .male:
            return LinearGradient(
                colors: [.blue.opacity(0.6), .blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .female:
            return LinearGradient(
                colors: [.pink.opacity(0.6), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .nA, .unknown:
            return LinearGradient(
                colors: [.gray.opacity(0.5), .gray.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    static func borderColor(for gender: Gender) -> Color {
        switch gender {
        case .male:
            return .blue
        case .female:
            return .pink
        case .nA, .unknown:
            return .gray
        }
    }
}

