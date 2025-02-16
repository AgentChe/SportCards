//
//  ParallelsView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import SwiftUI

struct ParallelsView: View {
    @EnvironmentObject private var route: NavigationManager
    private let cards: [CardDiscover]
    private let collection: CollectionTab
    
    init(cards: [CardDiscover], collection: CollectionTab) {
        self.cards = cards
        self.collection = collection
    }
    var body: some View {
        LazyVStack(spacing: 16.scale) {
            ForEach(cards) { card in
                NavigationLink(value: Route.cardDescription(id: card.cardId, grade: card.grade, collection: collection)) {
                    ParallelCardView(model: card)
                }
            }
        }
    }
}

#Preview {
    ParallelsView(cards: CardDiscover.mock, collection: .wishList)
}
