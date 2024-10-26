//
//  WishListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import SwiftUI

struct WishListView: View {
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel = WishListViewModel()
    @State private var layout: CollectionLayoutType = .list
    @Namespace private var wishAnim
    
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
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
    }
}

enum ScreenState {
    case loading
    case loaded
    case error
}

struct ScreenStateModifier: ViewModifier {
    @Binding var state: ScreenState
    let bottomOffset: CGFloat
    let tryAgain: () -> Void
    func body(content: Content) -> some View {
        switch state {
        case .loading:
            LoaderView(type: .fullScreen)
        case .loaded:
            content
        case .error:
            ErrorScreenView(errorType: .request, tryAgain: tryAgain)
                .padding(.bottom, bottomOffset)
        }
    }
}

extension View {
    func screenState(_ state: Binding<ScreenState>, bottomOffset: CGFloat = .zero, tryAgain: @escaping () -> Void) -> some View {
        modifier(ScreenStateModifier(state: state, bottomOffset: bottomOffset, tryAgain: tryAgain))
    }
}

private extension WishListView {
    @ViewBuilder
    func makeItem(card: CardDiscover) -> some View {
        Button(
            action: { router.push(to: .cardDescription(id: card.cardId, grade: card.grade, collection: .wishList))},
            label: {
                switch layout {
                case .list:
                    RecommendedCardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: wishAnim)
                case .grid:
                    CardGridView(card: card)
                        .matchedGeometryEffect(id: card.id, in: wishAnim)
                }
            }
        )
    }
}

#Preview {
    WishListView()
        .gradientBackground()
}
