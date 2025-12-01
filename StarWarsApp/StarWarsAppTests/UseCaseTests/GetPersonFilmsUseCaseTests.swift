//
//  GetPersonFilmsUseCaseTests.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import XCTest
@testable import StarWarsApp

final class GetPersonFilmsUseCaseTests: XCTestCase {
    
    // MARK: - Test 1 — Map films correctly and propagate isFromCache
    func test_execute_mapsFilmsCorrectly_andPropagatesCacheFlag() async throws {
        // GIVEN
        let mockRepo = MockFilmsRepository()
        let person = Person.mockLuke
        
        let sut = GetPersonFilmsUseCase(repository: mockRepo)
        
        // WHEN
        let result = try await sut.execute(for: person)
        
        // THEN
        XCTAssertEqual(result.value.count, 3)
        XCTAssertEqual(result.value.first?.title, Film.mock.title)
        XCTAssertFalse(result.isFromCache) //mock use isFromCache = false
    }
    
    // MARK: - Test 2 — remove duplicates
    func test_execute_removesDuplicates() async throws {
        // GIVEN
        let mockRepo = MockFilmsRepository()
        
        // Create a Person with duplicate films
        let duplicatePerson = Person(
            name: Person.mockLuke.name,
            gender: Person.mockLuke.gender,
            birthYear: Person.mockLuke.birthYear,
            films: [
                URL(string: "https://swapi.dev/api/films/1/")!,
                URL(string: "https://swapi.dev/api/films/1/")!
            ]
        )
        
        let sut = GetPersonFilmsUseCase(repository: mockRepo)
        
        // WHEN
        let result = try await sut.execute(for: duplicatePerson)
        
        // THEN
        XCTAssertEqual(
            result.value.count,
            1,
            "The UseCase must remove duplicates with uniqued(by:)"
        )
    }
    
    // MARK: - Test 3 — Ignores errors in some films
    func test_execute_ignoresFailedRequests_andKeepsValidOnes() async throws {
        // GIVEN
        final class ErrorMockRepo: FilmsRepositoryProtocol {
            func fetchFilm(by url: URL) async throws -> CachedResponse<FilmDTO> {
                // only episode 2 is faulty, for example
                if url.absoluteString.contains("/2/") {
                    throw URLError(.badServerResponse)
                }
                
                let film = Film.mock
                let dto = FilmDTO(
                    title: film.title,
                    director: film.director,
                    releaseDate: DateFormatter.starWarsAPIDate.string(from: film.releaseDate),
                    url: url,
                    episodeID: 1
                )
                return CachedResponse(value: dto, isFromCache: true)
            }
        }
        
        let repo = ErrorMockRepo()
        let person = Person.mockLuke // films: 1,2,3
        
        let sut = GetPersonFilmsUseCase(repository: repo)
        
        // WHEN
        let result = try await sut.execute(for: person)
        
        // THEN
        XCTAssertEqual(
            result.value.count,
            2,
            "You should only ignore the film that fails. (film 2)"
        )
        
        // Since all valid ones come from the cache → true
        XCTAssertTrue(result.isFromCache)
    }
}
