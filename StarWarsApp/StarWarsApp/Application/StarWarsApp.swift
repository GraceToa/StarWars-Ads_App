//
//  StarWarsApp.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

@main
struct StarWarsApp: App {

    var body: some Scene {
        WindowGroup {
            let httpClient = HTTPClient()
            let cache = DiskCache()
            let peopleRepository = PeopleRepository(client: httpClient, cache: cache)
            let filmsRepository = FilmsRepository(client: httpClient, cache: cache)
            let adsProvider = FakeAdsProvider()
            let factory = ViewModelFactory(
                peopleRepository: peopleRepository,
                filmsRepository: filmsRepository,
                adsProvider: adsProvider
            )
            RootView(factory: factory)
        }
    }
}

