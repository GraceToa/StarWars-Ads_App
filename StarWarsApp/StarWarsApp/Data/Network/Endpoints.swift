//
//  Endpoints.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Centralized definition of all SWAPI endpoints used in the app.
/// This makes it easier to maintain and extend the API surface.
enum Endpoint {
    case people(page: Int)
    
    var url: URL? {
        switch self {
        case .people(let page):
            return URL(string: "https://swapi.dev/api/people/?page=\(page)")
        }
    }
}
