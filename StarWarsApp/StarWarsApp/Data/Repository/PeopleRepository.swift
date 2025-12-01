//
//  PeopleRepository.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Handles API requests, local caching, and offline access.
final class PeopleRepository: PeopleRepositoryProtocol {
    
    // MARK: - Properties
    private let client: HTTPClientProtocol
    private let cache: DiskCacheProtocol
    
    // MARK: - Init
    init(client: HTTPClientProtocol, cache: DiskCacheProtocol = DiskCache()) {
        self.client = client
        self.cache = cache
    }
    
    // MARK: - Public API
    func fetchPage(_ page: Int) async throws -> CachedResponse<PeoplePageDTO> {
        guard let url = Endpoint.people(page: page).url else {
            throw NetworkError.invalidURL
        }
        
        let cacheKey = "people_page_\(page)"
        
        // 1) try Remote
        do {
            let remoteDTO: PeoplePageDTO = try await client.fetch(PeoplePageDTO.self, from: url)
            if let data = try? JSONEncoder().encode(remoteDTO) {
                try? cache.save(data, forKey: cacheKey)
            }
            return CachedResponse(value: remoteDTO, isFromCache: false)
        } catch {
            // 2) If the network fails, try CACHÉ
            if let cachedData = try? cache.load(forKey: cacheKey),
               let cachedDTO = try? JSONDecoder().decode(PeoplePageDTO.self, from: cachedData) {
                return CachedResponse(value: cachedDTO, isFromCache: true)
            } else {
                throw error
            }
        }
    }
    
    // MARK: - Private Helpers
    /// Fetches the latest version of a people page and updates the cache.
    private func refreshPage(_ page: Int, key: String, url: URL) async throws -> PeoplePageDTO {
        let remoteDTO = try await client.fetch(PeoplePageDTO.self, from: url)
        if let data = try? JSONEncoder().encode(remoteDTO) {
            try? cache.save(data, forKey: key)
        }
        return remoteDTO
    }
}
