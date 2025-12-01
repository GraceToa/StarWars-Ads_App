//
//  OfflineBannerModifier.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import SwiftUI

/// A view modifier that displays a banner at the top of the content when the app is in offline mode.
/// Useful to indicate that the displayed data comes from the local cache instead of a remote source.
struct OfflineBannerModifier: ViewModifier {
    let isOffline: Bool
    let message: String

    // MARK: - Body
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if isOffline {
                HStack {
                    Label(message, systemImage: "wifi.slash")
                        .font(.footnote)
                        .foregroundColor(.orange)
                        .padding(.vertical, 6)
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color(.systemGray6))
            }
            
            content
        }
    }
}

extension View {
    func offlineBanner(isOffline: Bool, message: String = "Offline mode — showing cached data") -> some View {
        self.modifier(OfflineBannerModifier(isOffline: isOffline, message: message))
    }
}
