//
//  PeopleRepositoryProtocol.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the contract for fetching people from SWAPI or local cache.
protocol PeopleRepositoryProtocol: Sendable {
    func fetchPage(_ page: Int) async throws -> CachedResponse<PeoplePageDTO>
}
