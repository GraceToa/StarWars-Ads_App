//
//  FilmsRepository.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Handles fetching film details, caching, and offline access.
final class FilmsRepository: FilmsRepositoryProtocol {
    
    // MARK: - Properties
    private let client: HTTPClientProtocol
    private let cache: DiskCacheProtocol
    
    // MARK: - Init
    init(client: HTTPClientProtocol, cache: DiskCacheProtocol = DiskCache()) {
        self.client = client
        self.cache = cache
    }
    
    // MARK: - Public API
    func fetchFilm(by url: URL) async throws -> CachedResponse<FilmDTO> {
        let key = makeCacheKey(for: url)
        
        // 1) try Remote
        do {
            let remote: FilmDTO = try await client.fetch(FilmDTO.self, from: url)
            if let data = try? JSONEncoder().encode(remote) {
                try? cache.save(data, forKey: key)
            }
            return CachedResponse(value: remote, isFromCache: false)
        } catch {
            // 2) If the network fails, try CACHÉ
            if let cachedData = try? cache.load(forKey: key),
               let cached = try? JSONDecoder().decode(FilmDTO.self, from: cachedData) {
                return CachedResponse(value: cached, isFromCache: true)
            }
            throw error
        }
    }
    
    // MARK: - Helpers
    private func makeCacheKey(for url: URL) -> String {
        let cleanPath = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if let id = cleanPath.split(separator: "/").last {
            return "film_\(id)"
        } else {
            return "film_\(url.absoluteString.hashValue)"
        }
    }
    
}
