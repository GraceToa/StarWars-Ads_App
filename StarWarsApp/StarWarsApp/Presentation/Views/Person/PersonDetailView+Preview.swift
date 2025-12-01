//
//  PersonDetailView+Preview.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import SwiftUI

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHost()
            .previewDisplayName("Person Detail → Films → Sheet")
    }
    
    private struct PreviewHost: View {
        
        // MARK: - Dependencies
        let mockPeopleRepository = MockPeopleRepository()
        let mockFilmsRepository = MockFilmsRepository()
        let factory: MockViewModelFactory
        
        // MARK: - StateObjects (persist during preview)
        @StateObject private var navigationCoordinator = NavigationCoordinator()
        @StateObject private var personDetailViewModel: PersonDetailViewModel
        
        init() {
            let f = MockViewModelFactory(
                peopleRepository: mockPeopleRepository,
                filmsRepository: mockFilmsRepository
            )
            factory = f
            _personDetailViewModel = StateObject(
                wrappedValue: f.makePersonDetailViewModel(for: .mockLuke)
            )
        }
        
        var body: some View {
            NavigationStack(path: $navigationCoordinator.path) {
                PersonDetailView(viewModel: personDetailViewModel)
                    .id("personDetailPreview")
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
