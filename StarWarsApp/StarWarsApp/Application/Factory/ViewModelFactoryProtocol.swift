//
//  ViewModelFactoryProtocol.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Defines the contract for creating all ViewModels in the app.
 @MainActor
protocol ViewModelFactoryProtocol: Sendable {
    func makePeopleListViewModel() -> PeopleListViewModel
    func makePersonDetailViewModel(for person: Person) -> PersonDetailViewModel
}
