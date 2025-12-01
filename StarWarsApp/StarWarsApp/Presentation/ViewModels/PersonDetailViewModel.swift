//
//  PersonDetailViewModel.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import Foundation

/// Handles film loading and state management for the Person Detail screen.
@MainActor
final class PersonDetailViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published private(set) var films: [Film] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isOfflineMode: Bool = false
    
    // MARK: - Dependencies
    private let getPersonFilmsUseCase: GetPersonFilmsUseCaseProtocol
    private let person: Person
    
    // MARK: - Init
    init(person: Person, getPersonFilmsUseCase: GetPersonFilmsUseCaseProtocol) {
        self.person = person
        self.getPersonFilmsUseCase = getPersonFilmsUseCase
    }
    
    // MARK: - Public API
    func loadFilms() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        
        do {
            let result = try await getPersonFilmsUseCase.execute(for: person)
            await MainActor.run {
                self.films = result.value.sorted { $0.releaseDate < $1.releaseDate }
                self.isOfflineMode = result.isFromCache
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    var personInfo: Person {
        person
    }
    
    // MARK: - UI Helpers
    var birthYearText: String {
        "Birth Year: \(personInfo.birthYear.formatted)"
    }
}
