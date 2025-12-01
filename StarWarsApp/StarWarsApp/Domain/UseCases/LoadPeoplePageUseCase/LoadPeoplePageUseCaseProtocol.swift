//
//  Untitled.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the contract for loading a paginated list of people from SWAPI.
protocol LoadPeoplePageUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> CachedResponse<(people: [Person], nextPage: Int?)> 
}
