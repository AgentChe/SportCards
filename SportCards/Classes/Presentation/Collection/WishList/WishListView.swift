//
//  WishListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import SwiftUI

struct WishListView: View {
    @StateObject private var viewModel = WishListViewModel()
    @State private var layout: CollectionLayoutType = .list
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            CollectionSettingsView(
                currentLayout: $layout,
                filters: $viewModel.filters
            )
            .padding(.vertical, 24.scale)
            .padding(.horizontal, 16.scale)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: layout.columns, spacing: 16.scale) {
                    ForEach(viewModel.cards, id: \.id) { card in
                        switch layout {
                        case .list:
                            RecommendedCardView(card: card)
                        case .grid:
                            CardGridView(card: card)
                        }
                    }
                }
                .padding(.horizontal, 16.scale)
                .padding(.bottom, 32.scale)
            }
        }
        .overlay {
            if viewModel.cards.isEmpty {
                CardCollectionEmptyView()
                    .transition(.opacity)
            }
        }
        .onViewDidLoad {
            viewModel.makeData()
        }
    }
}

#Preview {
    WishListView()
}
