//
//  CardGridView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI
import NukeUI

struct CardGridView: View {
    let card: CardDiscover
    var body: some View {
        LazyImage(source: card.imageURL) { state in
            if let image = state.image {
                image
                    .resizingMode(.aspectFill)
                    .clipShape(RoundedRectangle(cornerRadius: 8.scale))
            } else {
                RoundedRectangle(cornerRadius: 8.scale)
                    .fill(.main200)
            }
        }
        .aspectRatio(0.7, contentMode: .fill)
    }
}

#Preview {
    ScrollView(.vertical) {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 17.5.scale), .init(.flexible(), spacing: 17.5.scale)], spacing: 16.scale) {
            ForEach(CardDiscover.mock) {
                CardGridView(card: $0)
            }
        }
        .padding(.horizontal, 16.scale)
    }
    .background(.black)
}
