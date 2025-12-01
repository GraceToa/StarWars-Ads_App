//
//  DateFormatter+starWarsAPIDate.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

extension DateFormatter {
    static let starWarsAPIDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
