//
//  FilmDTO.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

// MARK: - FilmDTO
///Data Transfer Object for a Star Wars film from the SWAPI.
struct FilmDTO: Codable, Equatable, Sendable {
    let title: String
    let director: String
    let releaseDate: String
    let url: URL
    let episodeID: Int?

    private enum CodingKeys: String, CodingKey {
        case title
        case director
        case releaseDate = "release_date"
        case url
        case episodeID = "episode_id"
    }
}

// MARK: - Mapping to Domain
extension FilmDTO {
    func toDomain() -> Film {
        Film(
            url: url,
            title: title,
            director: director,
            releaseDate: DateFormatter.starWarsAPIDate.date(from: releaseDate) ?? .distantPast
        )
    }
}


