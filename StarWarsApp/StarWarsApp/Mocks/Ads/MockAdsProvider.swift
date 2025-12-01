//
//  MockAdsProvider.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

final class MockAdsProvider: AdsProviderProtocol {
    var adToReturn: AdModel = .mock
    var shouldThrow = false

    func loadAd() async throws -> AdModel {
        if shouldThrow { throw URLError(.badServerResponse) }
        return adToReturn
    }
}
