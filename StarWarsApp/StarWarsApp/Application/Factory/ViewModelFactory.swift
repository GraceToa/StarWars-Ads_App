//
//  ViewModelFactory.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

// MARK: - ViewModelFactory

/// Creates Use Cases and injects dependencies into ViewModels.
@MainActor
final class ViewModelFactory: ViewModelFactoryProtocol {

    // MARK: - Dependencies
    private let peopleRepository: PeopleRepositoryProtocol
    private let filmsRepository: FilmsRepositoryProtocol
    private let adsProvider: AdsProviderProtocol

    // MARK: - Init
    init(
        peopleRepository: PeopleRepositoryProtocol,
        filmsRepository: FilmsRepositoryProtocol,
        adsProvider: AdsProviderProtocol
    ) {
        self.peopleRepository = peopleRepository
        self.filmsRepository = filmsRepository
        self.adsProvider = adsProvider
    }

    // MARK: - ViewModel Creation
    func makePeopleListViewModel() -> PeopleListViewModel {
        let useCase = LoadPeoplePageUseCase(repository: peopleRepository)
        return PeopleListViewModel(loadPeoplePageUseCase: useCase, adsProvider: adsProvider)
    }

    func makePersonDetailViewModel(for person: Person) -> PersonDetailViewModel {
        let useCase = GetPersonFilmsUseCase(repository: filmsRepository)
        return PersonDetailViewModel(person: person, getPersonFilmsUseCase: useCase)
    }
}
