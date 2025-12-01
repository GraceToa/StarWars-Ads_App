//
//  AdRowView+Preview.swift
//  StarWarsApp
//
//  Created by Grace Toa on 17/11/25.
//

import SwiftUI

struct AdRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdRowView(ad: .mock)
                .previewDisplayName("Ad – Normal")
                .padding()
                .previewLayout(.sizeThatFits)
            
            AdRowView(ad: .unavailable)
                .previewDisplayName("Ad – Placeholder")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
