//
//  AdsProviderProtocol.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

///Returns a generated ad (fake or real depending on the implementation)
protocol AdsProviderProtocol {
    func loadAd() async throws -> AdModel
}
