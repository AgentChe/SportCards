//
//  ScannedListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import SwiftUI

struct ScannedListView: View {
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel = ScannedListViewModel()
    @State private var layout: CollectionLayoutType = .list
    @Namespace private var scannedAnim
    
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
                        makeItem(card: card)
                            .onAppear(perform: {
                                viewModel.makeLoadNext(card: card)
                            })
                    }
                }
                .padding(.horizontal, 16.scale)
                
                if !viewModel.isFinished {
                    LoaderView(type: .pagination)
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Color.clear.frame(height: 32.scale)
        })
        .frame(maxWidth: .infinity)
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
    }
}

private extension ScannedListView {
    @ViewBuilder
    func makeItem(card: CardDiscover) -> some View {
        Button(
            action: { router.push(to: .cardDescription(id: card.cardId, grade: card.grade, collection: .scanned))},
            label: {
                switch layout {
                case .list:
                    RecommendedCardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: scannedAnim)
                case .grid:
                    CardGridView(card: card)
                        .matchedGeometryEffect(id: card.id, in: scannedAnim)
                }
            }
        )
    }
    
    @ViewBuilder
    var contetnView: some View {
        if viewModel.cards.isEmpty {
            Spacer()
        } else {
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
                        makeItem(card: card)
                            .onAppear(perform: {
                                viewModel.makeLoadNext(card: card)
                            })
                    }
                }
                .padding(.horizontal, 16.scale)
                .padding(.bottom, viewModel.isFinished ? 32.scale : 0)
                
                if !viewModel.isFinished {
                    LoaderView(type: .pagination)
                        .padding(.bottom, 32.scale)
                }
            }
        }
    }
}

#Preview {
    ScannedListView()
}
