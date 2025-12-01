//
//  NavigationCoordinator.swift
//  StarWarsApp
//
//  Created by Grace Toa on 12/11/25.
//

import SwiftUI

/// Coordinates navigation using a shared NavigationPath.
/// Inject this object into the SwiftUI environment.
@MainActor
final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var activeSheet: AppSheet?
    
    // MARK: - Navigation stack
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    // MARK: - Sheets
    func present(_ sheet: AppSheet) {
        activeSheet = sheet
    }
    
    func dismiss() {
        activeSheet = nil
    }
    
    ///Clear all navigation routes and sheets
    func reset() {
        path = NavigationPath()
        activeSheet = nil
    }
}
