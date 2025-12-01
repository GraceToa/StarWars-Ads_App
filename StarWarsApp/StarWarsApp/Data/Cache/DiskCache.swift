//
//  DiskCache.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines a lightweight caching interface for saving and reading Data objects.
protocol DiskCacheProtocol: Sendable {
    func save(_ data: Data, forKey key: String) throws
    func load(forKey key: String) throws -> Data?
}

/// A simple file-based cache that stores JSON responses in the app's Documents directory.
final class DiskCache: DiskCacheProtocol {
    
    // MARK: - Properties
    private let fileManager: FileManager
    private let directoryURL: URL
    
    // MARK: - Init
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Cache", isDirectory: true)
        createCacheDirectoryIfNeeded()
    }
    
    // MARK: - Public API
    func save(_ data: Data, forKey key: String) throws {
        let fileURL = path(for: key)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func load(forKey key: String) throws -> Data? {
        let fileURL = path(for: key)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        return try Data(contentsOf: fileURL)
    }
    
    // MARK: - Helpers
    private func path(for key: String) -> URL {
        directoryURL.appendingPathComponent("\(key).json")
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: directoryURL.path) else { return }
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }
}
