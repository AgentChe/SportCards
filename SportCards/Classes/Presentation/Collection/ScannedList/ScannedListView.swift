//
//  ScannedListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import SwiftUI

struct ScannedListView: View {
    @StateObject private var viewModel = ScannedListViewModel()
    @State private var layout: CollectionLayoutType = .list
    
    var body: some View {
        VStack(spacing: 0) {
            if let model = viewModel.price {
                CollectionTotalHeader(model: model)
                    .padding(.horizontal, 16.scale)
                    .padding(.top, 24.scale)
            }
            
            CollectionSettingsView(
                currentLayout: $layout,
                filters: $viewModel.filters
            )
            .padding(.vertical, 24.scale)
            .padding(.horizontal, 16.scale)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: layout.columns, spacing: 16.scale) {
                    ForEach(viewModel.cards) { card in
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
                CardCollectionEmptyView().gradientBackground()
                    .transition(.opacity)
            }
        }
        .onViewDidLoad {
            viewModel.makeData()
        }
    }
}

#Preview {
    ScannedListView()
}
