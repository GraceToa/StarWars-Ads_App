//
//  Untitled.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

// MARK: - PeoplePageDTO
struct PeoplePageDTO: Codable, Equatable, Sendable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [PersonDTO]
}
