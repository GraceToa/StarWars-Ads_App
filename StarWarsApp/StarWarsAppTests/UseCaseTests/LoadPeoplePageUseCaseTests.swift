//
//  LoadPeoplePageUseCaseTests.swift
//  StarWarsAppTests
//
//  Created by Grace Toa on 13/11/25.
//

import XCTest
@testable import StarWarsApp

final class LoadPeoplePageUseCaseTests: XCTestCase {
    
    // MARK: - Test 1 — returns correctly mapped people
    func test_execute_returnsMappedPeople() async throws {
        // GIVEN
        let mockRepo = MockPeopleRepository()
        let sut = LoadPeoplePageUseCase(repository: mockRepo)
        
        // WHEN
        let result = try await sut.execute(page: 1)
        
        // THEN
        XCTAssertEqual(result.value.people.count, 2)
        XCTAssertEqual(result.value.people[0].name, Person.mockLuke.name)
        XCTAssertEqual(result.value.people[1].name, Person.mockLeia.name)
        XCTAssertNil(result.value.nextPage) //mock always next == nil
        XCTAssertFalse(result.isFromCache) //mock return isFromCache = false
    }
    
    // MARK: - Test 2 — The error is propagated when the repository fails.
    func test_execute_whenRepositoryThrows_propagatesError() async {
        // GIVEN
        final class ErrorMockRepo: PeopleRepositoryProtocol {
            func fetchPage(_ page: Int) async throws -> CachedResponse<PeoplePageDTO> {
                throw URLError(.badServerResponse)
            }
        }
        
        let sut = LoadPeoplePageUseCase(repository: ErrorMockRepo())
        
        // WHEN
        do {
            _ = try await sut.execute(page: 1)
            XCTFail("Expected URLError.badServerResponse but no error was thrown")
        } catch let error as URLError {
            // THEN
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
