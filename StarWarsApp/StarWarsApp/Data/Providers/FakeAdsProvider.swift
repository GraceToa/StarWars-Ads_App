//
//  FakeAdsProvider.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

/*
 Simulate a network call with Task.sleep, generate a random title, and create a random banner using Picsum
 Data -> FakeAdsProvider
 Domain → AdsProviderProtocol
 Presentation → ViewModels y Views just come AdModel
 In the future, this provider can be replaced with a real one from the internal SDK without touching the ViewModel.
 */

final class FakeAdsProvider: AdsProviderProtocol {

    func loadAd() async throws -> AdModel {
        // Simulate a small network delay (0.3s)
        try await Task.sleep(nanoseconds: 300_000_000)

        // We generated a pseudo-random title
        let titles = [
            "Oferta Jedi del Día",
            "¡Descuento Imperial!",
            "Promoción Galáctica",
            "Rebajas en Tatooine",
            "Créditos Galácticos x2"
        ]
        
        let randomTitle = titles.randomElement() ?? "Special Announcement"

        // Picsum image in banner size
        let randomImageURL = URL(string: "https://picsum.photos/600/300?random=\(Int.random(in: 1...10_000))")!

        // False action (in case links are desired in the future)
        let actionURL = URL(string: "https://www.starwars.com")

        let dto = AdDTO(
            title: randomTitle,
            imageURL: randomImageURL,
            actionURL: actionURL
        )

        return dto.toDomain()
    }
}
