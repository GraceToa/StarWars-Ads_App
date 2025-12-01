//
//  Film.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Domain model representing a Star Wars film.
struct Film: Identifiable, Equatable, Hashable, Sendable {
    let url: URL
    let title: String
    let director: String
    let releaseDate: Date
    
    /// Unique identifier derived from the film's URL.
    var id: String { url.absoluteString }
    
    static func == (lhs: Film, rhs: Film) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension Film {    
    static let mock: Film = {
        return Film(
            url: URL(string: "https://swapi.dev/api/films/1/")!,
            title: "A New Hope",
            director: "George Lucas",
            releaseDate: DateFormatter.mediumStyle.date(from: "1977-05-25") ?? .now
        )
    }()

    static let mockANewHope = Film(
        url: URL(string: "https://swapi.dev/api/films/1/")!,
        title: "A New Hope",
        director: "George Lucas",
        releaseDate: DateFormatter.mediumStyle.date(from: "1977-05-25") ?? .now
    )

    static let mockEmpireStrikesBack = Film(
        url: URL(string: "https://swapi.dev/api/films/2/")!,
        title: "The Empire Strikes Back",
        director: "Irvin Kershner",
        releaseDate: DateFormatter.mediumStyle.date(from: "1980-05-17") ?? .now
    )

    static let mockReturnOfTheJedi = Film(
        url: URL(string: "https://swapi.dev/api/films/3/")!,
        title: "Return of the Jedi",
        director: "Richard Marquand",
        releaseDate: DateFormatter.mediumStyle.date(from: "1983-05-25") ?? .now
    )
}
