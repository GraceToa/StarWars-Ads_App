//
//  LoadPeoplePageUseCase.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Fetches a page of people, maps them to domain entities,
/// and returns both the data and the next page number if available.
final class LoadPeoplePageUseCase: LoadPeoplePageUseCaseProtocol {
    
    // MARK: - Properties
    private let repository: PeopleRepositoryProtocol
    
    // MARK: - Init
    init(repository: PeopleRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public API
    func execute(page: Int) async throws -> CachedResponse<(people: [Person], nextPage: Int?)> {
        let response = try await repository.fetchPage(page)
        let dto = response.value
        
        let mappedPeople = dto.results.map { $0.toDomain() }
        
        let nextPage: Int? = {
            guard let nextURL = dto.next,
                  let components = URLComponents(url: nextURL, resolvingAgainstBaseURL: false),
                  let queryItem = components.queryItems?.first(where: { $0.name == "page" }),
                  let pageString = queryItem.value,
                  let number = Int(pageString)
            else { return nil }
            return number
        }()
        
        return CachedResponse(
            value: (people: mappedPeople, nextPage: nextPage),
            isFromCache: response.isFromCache
        )
    }
}

