//
//  DateFormatter+FilmDetail.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

extension DateFormatter {
    static let mediumStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
