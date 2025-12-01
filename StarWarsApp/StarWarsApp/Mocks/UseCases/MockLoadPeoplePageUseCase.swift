//
//  MockLoadPeoplePageUseCase.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

final class MockLoadPeoplePageUseCase: LoadPeoplePageUseCaseProtocol {

    var executedPages: [Int] = []
    var result: CachedResponse<(people: [Person], nextPage: Int?)>!
    var shouldThrow = false

    func execute(page: Int) async throws -> CachedResponse<(people: [Person], nextPage: Int?)> {
        executedPages.append(page)

        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return result
    }
}
