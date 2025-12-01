//
//  FilmRowView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

struct FilmRowView: View {
    let film: Film

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(film.title)
                .font(.headline)
            Text("Director: \(film.director)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Release: \(formattedDate(film.releaseDate))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
