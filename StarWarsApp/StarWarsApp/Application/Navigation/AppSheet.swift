//
//  AppSheet.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines modal sheets presented within the app.
enum AppSheet: Identifiable {
    case filmDetail(Film)
    
    var id: String {
        switch self {
        case .filmDetail(let film):
            return film.url.absoluteString
        }
    }
}
