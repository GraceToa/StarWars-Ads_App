//
//  MockPeopleRepository.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

final class MockPeopleRepository: PeopleRepositoryProtocol {
    func fetchPage(_ page: Int) async throws -> CachedResponse<PeoplePageDTO> {
        let mockLuke = Person.mockLuke
        let mockLeia = Person.mockLeia

        let personDTO1 = PersonDTO(
            name: mockLuke.name,
            birthYear: mockLuke.birthYear.rawValue,
            gender: mockLuke.gender.rawValue,
            films: mockLuke.films.map { $0.absoluteString },
            url: URL(string: "https://swapi.dev/api/people/1/")!
        )
        
        let personDTO2 = PersonDTO(
            name: mockLeia.name,
            birthYear: mockLeia.birthYear.rawValue,
            gender: mockLeia.gender.rawValue,
            films: mockLeia.films.map { $0.absoluteString },
            url: URL(string: "https://swapi.dev/api/people/1/")!
        )
        
        let dto = PeoplePageDTO(
            count: 1,
            next: nil,
            previous: nil,
            results: [personDTO1,personDTO2]
        )
        
        return CachedResponse(value: dto, isFromCache: false)
    }
}
