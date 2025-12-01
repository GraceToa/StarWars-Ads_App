//
//  AdRowView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 17/11/25.
//

import SwiftUI

/// The list will automatically display ads every 5 characters, with real images from Picsum.
struct AdRowView: View {
    let ad: AdModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            /// Render image if available; show placeholder or loader when missing.
            AsyncImage(url: ad.imageURL) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    placeholder       /// Fallback when image fails to load
                case .empty:
                    ProgressView()    /// Loading state
                @unknown default:
                    placeholder
                }
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 3)
            
            /// Ad title (dynamic or placeholder)
            Text(ad.title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
    
    /// Placeholder shown when image is unavailable
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.25))
            
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.gray)
                .font(.largeTitle)
        }
    }
}
