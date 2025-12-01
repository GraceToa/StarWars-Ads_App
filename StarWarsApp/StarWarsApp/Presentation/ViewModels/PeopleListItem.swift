//
//  PeopleListItem.swift
//  StarWarsApp
//
//  Created by Grace Toa on 14/11/25.
//

import Foundation

///PeopleListView it will load two different types of cells
enum PeopleListItem: Identifiable, Equatable {
    case person(Person)
    case ad(AdModel)
    
    var id: UUID {
        switch self {
        case .person(let person):
            return person.id
        case .ad(let ad):
            return ad.id
        }
    }
}
