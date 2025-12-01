//
//  PersonRowView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Displays a single row in the list with avatar, name, and birth year.
struct PersonRowView: View {
    
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    let person: Person
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            GenderAvatarView(person: person)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)
                Text(person.birthYear.formatted)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .onTapGesture {
            navigationCoordinator.navigate(to: .personDetail(person))
        }
    }
}
