//
//  MockGetPersonFilmsUseCase.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

final class MockGetPersonFilmsUseCase: GetPersonFilmsUseCaseProtocol {

    var result: CachedResponse<[Film]>!
    var shouldThrow = false
    var executedForPerson: Person?

    func execute(for person: Person) async throws -> CachedResponse<[Film]> {
        executedForPerson = person
        
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return result
    }
}
