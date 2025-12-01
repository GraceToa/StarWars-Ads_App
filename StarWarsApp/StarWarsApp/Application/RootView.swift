//
//  RootView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Root composition view containing the NavigationStack and global state.
struct RootView: View {
    
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @StateObject private var peopleListViewModel: PeopleListViewModel
    
    //stable storage for PersonDetailViewModels
    @State private var personDetailViewModels: [UUID: PersonDetailViewModel] = [:]
    
    private let factory: ViewModelFactoryProtocol
    
    // MARK: - Init
    init(factory: ViewModelFactoryProtocol) {
        self.factory = factory
        _peopleListViewModel = StateObject(wrappedValue: factory.makePeopleListViewModel())
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            PeopleListView(viewModel: peopleListViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .personDetail(let person):
                        // Retrieve or create the ViewModel
                        PersonDetailView(viewModel: getViewModel(for: person))
                    }
                }
        }
        .environmentObject(navigationCoordinator)
        .sheet(item: $navigationCoordinator.activeSheet) { sheet in
            switch sheet {
            case .filmDetail(let film):
                FilmDetailView(film: film)
            }
        }
        
    }
    
    func getViewModel(for person: Person) -> PersonDetailViewModel {
        if let existing = personDetailViewModels[person.id] {
            return existing
        }
        let newVM = factory.makePersonDetailViewModel(for: person)
        personDetailViewModels[person.id] = newVM
        return newVM
    }

}
