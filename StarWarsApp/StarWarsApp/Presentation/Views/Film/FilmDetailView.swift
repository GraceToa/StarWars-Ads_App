//
//  FilmDetailView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

struct FilmDetailView: View {
    let film: Film
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Text(film.title)
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                Text("Director: \(film.director)")
                    .font(.headline)
                Text("Release: \(DateFormatter.mediumStyle.string(from: film.releaseDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(40)
        .presentationDetents([.medium, .large])
    }
}
