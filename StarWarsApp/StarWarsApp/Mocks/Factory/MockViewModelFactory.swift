//
//  MockViewModelFactory.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

@MainActor
final class MockViewModelFactory: ViewModelFactoryProtocol {

    // MARK: - Dependencies (Mocked)
    private let peopleRepository: PeopleRepositoryProtocol
    private let filmsRepository: FilmsRepositoryProtocol
    private let adsProvider: AdsProviderProtocol

    // MARK: - Init
    init(
        peopleRepository: PeopleRepositoryProtocol = MockPeopleRepository(),
        filmsRepository: FilmsRepositoryProtocol = MockFilmsRepository(),
        adsProvider: AdsProviderProtocol = MockAdsProvider()
    ) {
        self.peopleRepository = peopleRepository
        self.filmsRepository = filmsRepository
        self.adsProvider = adsProvider
    }

    // MARK: - ViewModel Creation (Mocked)
    func makePeopleListViewModel() -> PeopleListViewModel {
        let useCase = LoadPeoplePageUseCase(repository: peopleRepository)
        return PeopleListViewModel(
            loadPeoplePageUseCase: useCase,
            adsProvider: adsProvider
        )
    }

    func makePersonDetailViewModel(for person: Person) -> PersonDetailViewModel {
        let useCase = GetPersonFilmsUseCase(repository: filmsRepository)
        return PersonDetailViewModel(person: person, getPersonFilmsUseCase: useCase)
    }
}
