//
//  PeopleListViewModelTests.swift
//  StarWarsAppTests
//
//  Created by Grace Toa on 13/11/25.
//

import XCTest
@testable import StarWarsApp

@MainActor
final class PeopleListViewModelTests: XCTestCase {
    
    // MARK: - Test 1 — loadPage add people
    func test_loadPage_appendsPeople_andUpdatesNextPage() async {
        // GIVEN
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (people: [Person.mockLuke, Person.mockLeia], nextPage: 2),
            isFromCache: false
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        
        // WHEN
        await sut.reload()
        
        // THEN
        XCTAssertEqual(sut.people.count, 2)
        XCTAssertEqual(sut.nextPage, 2)
        XCTAssertFalse(sut.isOfflineMode)
        XCTAssertTrue(sut.hasLoaded)
        XCTAssertEqual(mockLoadPeopleUseCase.executedPages, [1])
    }
    
    // MARK: - Test 2 — loadPage handles isLoading correctly
    func test_loadPage_setsLoadingState() async {
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (people: [Person.mockLuke], nextPage: nil),
            isFromCache: false
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        
        // WHEN
        XCTAssertFalse(sut.isLoading)
        await sut.reload()
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - Test 3 — Errors are reflected in the error message.
    func test_loadPage_errorSetsErrorMessage() async {
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        mockLoadPeopleUseCase.shouldThrow = true
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        
        // WHEN
        await sut.reload()
        
        // THEN
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.people.isEmpty)
    }
    
    // MARK: - Test 4 — offlineMode reflects the cache
    func test_loadPage_setsOfflineMode() async {
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (people: [Person.mockLuke], nextPage: nil),
            isFromCache: true
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        
        // WHEN
        await sut.reload()
        
        // THEN
        XCTAssertTrue(sut.isOfflineMode)
    }
    
    // MARK: - Test 5 — loadNextPageIfNeeded only loads at the end
    func test_loadNextPageIfNeeded_loadsOnlyWhenLastVisibleItemReached() async {
        // GIVEN
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (
                people: [Person.mockLuke, Person.mockLeia],
                nextPage: 2
            ),
            isFromCache: false
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        // first load:
        await sut.reload()
        
        // simulated for page 2
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (people: [Person.mockLuke], nextPage: nil),
            isFromCache: false
        )
        
        // WHEN — We call loadNextPageIfNeeded using the last character
        let lastItem = sut.people.last!
        await sut.loadNextPageIfNeeded(currentItem: lastItem)
        
        // THEN
        XCTAssertEqual(mockLoadPeopleUseCase.executedPages, [1, 2], "Must load page 2 once")
    }
    
    // MARK: - Test 6 — loadNextPageIfNeeded It will NOT load if it is not the last item
    func test_loadNextPageIfNeeded_doesNotLoadIfNotLastItem() async {
        let mockLoadPeopleUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        mockLoadPeopleUseCase.result = CachedResponse(
            value: (
                people: [Person.mockLuke, Person.mockLeia],
                nextPage: 2
            ),
            isFromCache: false
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockLoadPeopleUseCase,
            adsProvider: mockAdsProvider
        )
        // first load
        await sut.reload()
        
        // WHEN —  move on to the FIRST item (not the last one)
        await sut.loadNextPageIfNeeded(currentItem: sut.people.first!)
        
        // THEN
        XCTAssertEqual(mockLoadPeopleUseCase.executedPages, [1], "Page 2 should not load")
    }
    
    //MARK: - Test 1 - Automatic insertion of ads every N items
    func test_listItems_insertsAdsEveryXPeople() async {
        // GIVEN
        let mockUseCase = MockLoadPeoplePageUseCase()
        let mockAdsProvider = MockAdsProvider()
        
        let people = [
            Person.mockLuke, Person.mockLeia,
            Person.mockLuke, Person.mockLeia,
            Person.mockLuke,
            Person.mockLeia
        ]
        
        mockUseCase.result = CachedResponse(
            value: (
                people: people,
                nextPage: nil
            ),
            isFromCache: false
        )
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockUseCase,
            adsProvider: mockAdsProvider
        )
        
        // WHEN
        await sut.reload()
        let items = sut.listItems
        
        // THEN
        XCTAssertEqual(items.count, 7)   // 6 people + 1 ad
        
        // We verified that there was an advertisement on the items
        let insertedAd = items.first(where: { item in
            if case .ad = item { return true }
            return false
        })
        
        XCTAssertNotNil(insertedAd, "An advertisement must have been inserted in the appropriate position")
        
        // We verify that the inserted ad is the correct mockup
        if case .ad(let adModel) = insertedAd {
            XCTAssertEqual(adModel.title, AdModel.mock.title)
        } else {
            XCTFail("The item found is not a valid listing.")
        }
    }
    
    // MARK: - Test 2 — Fallback to the placeholder when AdsProvider fails
    func test_adsFallbackToPlaceholderWhenProviderFails() async {
        // GIVEN
        let mockUseCase = MockLoadPeoplePageUseCase()
        mockUseCase.result = CachedResponse(
            value: (people: Array(repeating: .mockLuke, count: 5), nextPage: nil),
            isFromCache: false
        )
        
        let failingAds = MockAdsProvider()
        failingAds.shouldThrow = true   // causes an error in loadAd()
        
        let sut = PeopleListViewModel(
            loadPeoplePageUseCase: mockUseCase,
            adsProvider: failingAds
        )
        
        // WHEN
        await sut.reload()
        let items = sut.listItems
        
        // THEN
        // Find the first inserted ad
        let insertedAd = items.first { item in
            if case .ad(_) = item { return true }
            return false
        }
        
        XCTAssertNotNil(insertedAd, "An ad must be inserted even if it fails to load.")
        
        if case .ad(let adModel) = insertedAd {
            XCTAssertNil(
                adModel.imageURL,
                "When the AdsProvider fails, the placeholder with imageURL nil should be used."
            )
            XCTAssertEqual(adModel.title, "Ad not available")
        } else {
            XCTFail("The inserted item is not an advertisement.")
        }
    }
}


