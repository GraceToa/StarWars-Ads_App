//
//  GetPersonFilmsUseCase.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Loads all films for a given Star Wars character concurrently.
/// Uses structured concurrency with `TaskGroup` for optimal performance.
final class GetPersonFilmsUseCase: GetPersonFilmsUseCaseProtocol {
    
    // MARK: - Dependencies
    private let repository: FilmsRepositoryProtocol
    
    // MARK: - Init
    init(repository: FilmsRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public API
    func execute(for person: Person) async throws -> CachedResponse<[Film]> {
        var films: [Film] = []
        var isFromCache = true
        
        await withTaskGroup(of: CachedResponse<Film?>.self) { group in
            for filmURL in person.films {
                group.addTask {
                    do {
                        let response = try await self.repository.fetchFilm(by: filmURL)
                        return CachedResponse(value: response.value.toDomain(), isFromCache: response.isFromCache)
                    } catch {
                        return CachedResponse(value: nil, isFromCache: true)
                    }
                }
            }
            
            for await result in group {
                if let film = result.value {
                    films.append(film)
                }
                /// If at least one response didn't come from the cache, we're not offline
                if result.isFromCache == false {
                    isFromCache = false
                }
            }
        }
        
        return CachedResponse(
            value: films.uniqued(by: \.url),
            isFromCache: isFromCache
        )
    }
}

