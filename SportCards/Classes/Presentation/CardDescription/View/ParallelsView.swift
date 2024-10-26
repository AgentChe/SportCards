//
//  ParallelsView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import SwiftUI

struct ParallelsView: View {
    let cards: [CardDiscover]
    var body: some View {
        VStack(spacing: 16.scale) {
            ForEach(cards) { card in
                ParallelCardView(model: card)
            }
        }
    }
}

#Preview {
    ParallelsView(cards: CardDiscover.mock)
}
