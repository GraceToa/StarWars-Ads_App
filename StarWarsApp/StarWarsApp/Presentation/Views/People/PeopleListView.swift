//
//  PeopleListView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Main list view that displays all people with endless scrolling.
struct PeopleListView: View {
    
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @ObservedObject var viewModel: PeopleListViewModel
    
    // MARK: - Body
    var body: some View {
        content
            .navigationTitle("Star Wars Characters")
            .task {
                if !viewModel.hasLoaded {
                    await viewModel.reload()
                }
            }
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Find Character")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.sortAscending = true
                        } label: {
                            Label("BirthDate ↑", systemImage: "arrow.up")
                        }
                        
                        Button {
                            viewModel.sortAscending = false
                        } label: {
                            Label("BirthDate ↓", systemImage: "arrow.down")
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
    }
}

extension PeopleListView {
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if let error = viewModel.errorMessage {
            ErrorView(message: error) {
                Task {
                    await viewModel.reload()
                }
            }
        } else if viewModel.people.isEmpty && viewModel.isLoading {
            LoadingView(title: "Loading characters...")
        } else {
            listView
        }
    }
    
    // MARK: - List View
    private var listView: some View {
        List {
            ForEach(viewModel.listItems) { item in
                switch item {
                case .person(let person):
                    PersonRowView(person: person)
                        .onAppear {
                            Task {
                                await viewModel.loadNextPageIfNeeded(currentItem: person)
                            }
                        }
                    
                case .ad(let ad):
                    AdRowView(ad: ad)
                        .listRowSeparator(.hidden)
                }
            }
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .offlineBanner(isOffline: viewModel.isOfflineMode, message: "Offline mode — showing cached people data")
    }
}
