//
//  PeopleListView+Preview.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import SwiftUI

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHost()
            .previewDisplayName("People List → Navigate → Person Detail → Sheet")
    }
    
    private struct PreviewHost: View {

        // MARK: - Dependencies
        let mockPeopleRepository = MockPeopleRepository()
        let mockFilmsRepository = MockFilmsRepository()
        let factory: MockViewModelFactory
        
        // MARK: - StateObjects (persist during preview)
        @StateObject var navigationCoordinator = NavigationCoordinator()
        @StateObject private var peopleListViewModel: PeopleListViewModel
        @StateObject private var personDetailViewModel: PersonDetailViewModel
        
        init() {
            let f = MockViewModelFactory(
                peopleRepository: mockPeopleRepository,
                filmsRepository: mockFilmsRepository
            )
            factory = f
            _peopleListViewModel = StateObject(
                wrappedValue: f.makePeopleListViewModel()
            )
            _personDetailViewModel = StateObject(
                wrappedValue: f.makePersonDetailViewModel(for: .mockLuke)
            )
        }
        
        var body: some View {
            NavigationStack(path: $navigationCoordinator.path) {                
                PeopleListView(viewModel: peopleListViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .personDetail:
                            PersonDetailView(viewModel: personDetailViewModel)
                                .id("detail")
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
    }
}
