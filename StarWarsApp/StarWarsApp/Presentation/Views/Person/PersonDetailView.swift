//
//  PersonDetailView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//


/// Displays a person's details and their associated films.
import SwiftUI

struct PersonDetailView: View {
    
    @ObservedObject var viewModel: PersonDetailViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        content
            .padding()
            .navigationTitle(viewModel.personInfo.name)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.loadFilms() }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 16) {
            headerSection
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                filmList(viewModel.films)
            }
        }
        .offlineBanner(
            isOffline: viewModel.isOfflineMode,
            message: "Offline mode — showing cached person data"
        )
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 8) {
            GenderAvatarView(person: viewModel.personInfo)
                .frame(width: 90, height: 90)
            
            Text(viewModel.personInfo.name)
                .font(.title2)
                .bold()
            
            Text(viewModel.birthYearText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Film List Section
    @ViewBuilder
    private func filmList(_ films: [Film]) -> some View {
        List {
            Section(header: Text("Films")) {
                ForEach(films) { film in
                    Button {
                        navigationCoordinator.activeSheet = .filmDetail(film)
                    } label: {
                        FilmRowView(film: film)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Loading
    private var loadingView: some View {
        ProgressView("Loading films...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error
    private func errorView(message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button {
                Task { await viewModel.loadFilms() }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
