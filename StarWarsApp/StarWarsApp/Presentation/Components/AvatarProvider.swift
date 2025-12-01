//
//  AvatarProvider.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Provides an appropriate avatar image for a given character.
/// Falls back to a gender-based SF Symbol when no custom image is available.
enum AvatarProvider {
    static func image(for person: Person) -> Image {
        // Try to find a matching local asset by name
        let imageName = normalizedName(person.name)
        
        if UIImage(named: imageName) != nil {
            return Image(imageName)
        } else {
            return fallback(for: person.gender)
        }
    }
    
    // MARK: - Private Helpers
    /// Maps the character name to a safe asset name.
    private static func normalizedName(_ name: String) -> String {
        name.lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
    }
    
    /// Provides a fallback SF Symbol based on gender.
    private static func fallback(for gender: Gender) -> Image {
        switch gender {
        case .male:
            return Image(systemName: "person.fill")
        case .female:
            return Image(systemName: "person.fill")
        case .nA, .unknown:
            return Image(systemName: "questionmark.circle.fill")
        }
    }
}
