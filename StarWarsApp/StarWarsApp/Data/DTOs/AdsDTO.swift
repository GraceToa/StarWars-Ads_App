//
//  AdsDTO.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

// MARK: - AdDTO
///Although we will use a fake provider, we will still define a clean DTO
struct AdDTO: Decodable {
    let title: String
    let imageURL: URL?
    let actionURL: URL?
}

// MARK: - Mapping to Domain
extension AdDTO {
    func toDomain() -> AdModel {
        AdModel(
            id: UUID(),
            title: title,
            imageURL: imageURL,
            actionURL: actionURL
        )
    }
}
