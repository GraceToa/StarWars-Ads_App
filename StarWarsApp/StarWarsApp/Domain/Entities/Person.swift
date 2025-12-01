//
//  Person.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

struct Person: Identifiable, Equatable, Sendable, Hashable {
    let id = UUID()
    let name: String
    let gender: Gender
    let birthYear: BirthYear
    let films: [URL]
}

extension Person {
    static let mockLuke = Person(
        name: "Luke Skywalker",
        gender: .male,
        birthYear: BirthYear("19BBY"),
        films: [
            URL(string: "https://swapi.dev/api/films/1/")!,
            URL(string: "https://swapi.dev/api/films/2/")!,
            URL(string: "https://swapi.dev/api/films/3/")!
        ]
    )
    
    static let mockLeia = Person(
        name: "Leia Organa",
        gender: .female,
        birthYear: BirthYear("19BBY"),
        films: [
            URL(string: "https://swapi.dev/api/films/1/")!,
            URL(string: "https://swapi.dev/api/films/6/")!
        ]
    )
}




