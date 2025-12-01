//
//  GenderAvatarView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Displays a custom avatar image with a themed Star Wars background.
struct GenderAvatarView: View {
    let person: Person
    
    // MARK: - Body
    var body: some View {
        AvatarProvider.image(for: person)
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(Color.starWarsBackground(for: person.gender))
            )
            .overlay(
                Circle()
                    .stroke(Color.borderColor(for: person.gender), lineWidth: 3)
            )
            .shadow(radius: 3)
            .padding(4)
    }
}

