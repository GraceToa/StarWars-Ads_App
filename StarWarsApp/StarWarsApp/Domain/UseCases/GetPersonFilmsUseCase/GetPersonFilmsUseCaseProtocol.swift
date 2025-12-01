//
//  GetPersonFilmsUseCaseProtocol.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the contract for retrieving all films associated with a given person.
protocol GetPersonFilmsUseCaseProtocol: Sendable {
    func execute(for person: Person) async throws -> CachedResponse<[Film]> 
}
