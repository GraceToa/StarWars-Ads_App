//
//  PeopleListViewModel+Filters.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import Foundation

/// People filtered by search text and sorted by birth date.
extension PeopleListViewModel {
    var filteredPeople: [Person] {
        let base = people
        
        // 1) Search filter
        let searched = searchText.isEmpty
        ? base
        : base.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        // 2) Sorting by birth date
        return searched.sorted {
            sortAscending ? $0.birthYear < $1.birthYear
            : $0.birthYear > $1.birthYear
        }
    }
}
