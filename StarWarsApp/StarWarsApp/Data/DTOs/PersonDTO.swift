//
//  PersonDTO.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

// MARK: - PersonDTO
///Data Transfer Object for a Star Wars person from the SWAPI.
struct PersonDTO: Codable, Equatable, Sendable, Identifiable {
    var id: String { url.absoluteString }

    let name: String
    let birthYear: String
    let gender: String
    let films: [String]
    let url: URL

    private enum CodingKeys: String, CodingKey {
        case name
        case birthYear = "birth_year"
        case gender
        case films
        case url
    }
}

// MARK: - Mapping to Domain
extension PersonDTO {
    func toDomain() -> Person {
        Person(
            name: name,
            gender: Gender(from: gender),
            birthYear: BirthYear(birthYear),
            films: films.compactMap { URL(string: $0) }
        )
    }
}
