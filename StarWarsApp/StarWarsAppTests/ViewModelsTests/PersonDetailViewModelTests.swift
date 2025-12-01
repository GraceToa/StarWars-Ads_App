//
//  PersonDetailViewModelTests.swift
//  StarWarsAppTests
//
//  Created by Grace Toa on 13/11/25.
//

import XCTest
@testable import StarWarsApp

@MainActor
final class PersonDetailViewModelTests: XCTestCase {

    // MARK: - Test 1 — correct film loading
    func test_loadFilms_updatesFilmsAndOfflineState() async {
        // GIVEN
        let mockUseCase = MockGetPersonFilmsUseCase()

        mockUseCase.result = CachedResponse(
            value: [Film.mockANewHope, Film.mockEmpireStrikesBack],
            isFromCache: true
        )

        let sut = PersonDetailViewModel(
            person: Person.mockLuke,
            getPersonFilmsUseCase: mockUseCase
        )

        // WHEN
        await sut.loadFilms()

        // THEN
        XCTAssertEqual(mockUseCase.executedForPerson?.name, Person.mockLuke.name)
        XCTAssertEqual(sut.films.count, 2)
        XCTAssertTrue(sut.isOfflineMode)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }


    // MARK: - Test 2 — Error handling
    func test_loadFilms_setsErrorMessageOnFailure() async {
        // GIVEN
        let mockUseCase = MockGetPersonFilmsUseCase()
        mockUseCase.shouldThrow = true

        let sut = PersonDetailViewModel(
            person: Person.mockLuke,
            getPersonFilmsUseCase: mockUseCase
        )

        // WHEN
        await sut.loadFilms()

        // THEN
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.films.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Test 3 — personInfo exposes the correct model
    func test_personInfo_returnsPassedPerson() {
        let mockUseCase = MockGetPersonFilmsUseCase()
        let sut = PersonDetailViewModel(
            person: Person.mockLeia,
            getPersonFilmsUseCase: mockUseCase
        )

        XCTAssertEqual(sut.personInfo.name, "Leia Organa")
        XCTAssertEqual(sut.birthYearText, "Birth Year: 19BBY")
    }
}
