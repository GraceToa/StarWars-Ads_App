//
//  LoadingView.swift
//  StarWarsApp
//
//  Created by Grace Toa on 13/11/25.
//

import SwiftUI

struct LoadingView: View {
    let title: String
    
    // MARK: - Body
    var body: some View {
        VStack {
            ProgressView(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
