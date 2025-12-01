//
//  PeopleListViewModel.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Manages the state and pagination logic for the people list screen.
@MainActor
final class PeopleListViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published private(set) var people: [Person] = []
    /// True while a page is actively loading.
    @Published private(set) var isLoading: Bool = false
    /// True once the initial load has finished, preventing redundant API calls.
    @Published private(set) var hasLoaded: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var nextPage: Int? = 1
    @Published private(set) var isOfflineMode: Bool = false
    
    // Search + Sorting
    @Published var searchText: String = ""
    @Published var sortAscending: Bool = true
    
    // MARK: - Dependencies
    private let loadPeoplePageUseCase: LoadPeoplePageUseCaseProtocol
    private let adsProvider: AdsProviderProtocol
    
    // MARK: - Ads
    /// Display an ad every X people
    private let adFrequency: Int = 4
    /// Cache of precalculated ads indexed by item position
    private var cachedAds: [Int: AdModel] = [:]
    
    // MARK: - Init
    init(
        loadPeoplePageUseCase: LoadPeoplePageUseCaseProtocol,
        adsProvider: AdsProviderProtocol
    ) {
        self.loadPeoplePageUseCase = loadPeoplePageUseCase
        self.adsProvider = adsProvider
    }
    
    // MARK: - Public API
    /// Loads the next page when the user reaches the last visible person.
    /// Pagination works even when search/sorting are applied.
    func loadNextPageIfNeeded(currentItem: Person? = nil) async {
        guard let nextPage = nextPage, !isLoading else { return }
        guard let currentItem = currentItem else { return }
        guard let lastVisible = filteredPeople.last else { return }
        
        // Only paginate when the user reaches the last visible item
        guard lastVisible.id == currentItem.id else { return }
        
        await loadPage(page: nextPage)
    }
    
    /// Reloads all characters from page 1 and rests ads.
    func reload() async {
        people.removeAll()
        nextPage = 1
        hasLoaded = false
        await loadPage(page: 1)
        hasLoaded = true
    }
    
    // MARK: - Computed: People + Ads
    /// Combines people + interleaved ads into a hybrid list for presentation.
    /// Domain data (`people`) is kept separate from UI items; ads never pollute the domain state.
    var listItems: [PeopleListItem] {
        var items: [PeopleListItem] = []
        
        for (index, person) in filteredPeople.enumerated() {
            items.append(.person(person))
            
            /// Insert an ad every N people (if we have one cached)
            if index > 0, index % adFrequency == 0 {
                if let ad = cachedAds[index] {
                    items.append(.ad(ad))
                }
            }
        }
        return items
    }
    
    // MARK: - Private Helpers
    /// Loads a specific page of characters and preloads ads for the new indices.
    private func loadPage(page: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        errorMessage = nil
        
        do {
            let response = try await loadPeoplePageUseCase.execute(page: page)
            let (newPeople, next) = response.value
            
            let previusCount = self.people.count
            
            people.append(contentsOf: newPeople)
            self.nextPage = next
            self.isOfflineMode = response.isFromCache
            
            /// Preload ads that will correspond to the new item range
            await preloadAdsIfNeeded(
                startIndex: previusCount,
                addedCount: newPeople.count
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func preloadAdsIfNeeded(startIndex: Int, addedCount: Int) async {
        let endIndex = startIndex + addedCount
        
        for index in startIndex..<endIndex {
            if index > 0, index % adFrequency == 0 {
                if cachedAds[index] != nil { continue }
                
                do {
                    let ad = try await adsProvider.loadAd()
                    cachedAds[index] = ad
                } catch {
                    cachedAds[index] = AdModel.unavailable
                }
            }
        }
    }
}
