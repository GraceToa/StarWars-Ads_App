//
//  MockFilmsRepository.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

final class MockFilmsRepository: FilmsRepositoryProtocol {

    func fetchFilm(by url: URL) async throws -> CachedResponse<FilmDTO> {
        let film = Film.mock

        let dto = FilmDTO(
            title: film.title,
            director: film.director,
            releaseDate: DateFormatter.starWarsAPIDate.string(from: film.releaseDate),
            url: url,
            episodeID: 1
        )

        return CachedResponse(value: dto, isFromCache: false)
    }
}

