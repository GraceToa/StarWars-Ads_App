//
//  AdModel.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

struct AdModel: Identifiable, Equatable {
    let id: UUID
    let title: String
    let imageURL: URL?
    let actionURL: URL? //to simulate a tap
}

extension AdModel {
    static var unavailable: AdModel {
        AdModel(
            id: UUID(),
            title: "Ad not available",
            imageURL: nil,
            actionURL: nil
        )
    }
    
    static var mock: AdModel {
        AdModel(
            id: UUID(),
            title: "Jedi Deal of the Day",
            imageURL: URL(string: "https://picsum.photos/600/300"),
            actionURL: URL(string: "https://www.starwars.com")
        )
    }
}
