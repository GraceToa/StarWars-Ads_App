//
//  FilmsRepositoryProtocol.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the contract for retrieving film details from SWAPI or local cache.
protocol FilmsRepositoryProtocol: Sendable {
    func fetchFilm(by url: URL) async throws -> CachedResponse<FilmDTO> 
}
