//
//  HomeSearch.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import SwiftUI

extension View {
    func homeSearchable() -> some View {
        modifier(HomeSearchableModifier())
    }
}

private struct HomeSearchableModifier: ViewModifier {
    @State private var isFocused: Bool = false
    @StateObject private var viewModel = CardSearchViewModel()
    
    func body(content: Content) -> some View {
        let isSearch = isFocused || !viewModel.searchText.isEmpty
        VStack(spacing: 0) {
            SearchView(searchText: $viewModel.searchText, isFocused: $isFocused, filters: $viewModel.filters)
                .padding(.init(top: 14.scale, leading: 16.scale, bottom: 24.scale, trailing: 16.scale))
            if isSearch {
                HomeSearchView(viewModel: viewModel)
                    .overlay(overlayView)
            } else {
                content
            }
        }
    }
    
    @ViewBuilder
    var overlayView: some View {
        if viewModel.elements.isEmpty {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }
        }
    }
}

private struct HomeSearchView: View {
    @EnvironmentObject private var router: NavigationManager
    @ObservedObject var viewModel: CardSearchViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.elements) { item in
                Button(
                    action: { router.push(to: .cardDescription(id: item.cardId, grade: item.grade, collection: .wishList)) },
                    label: { RecommendedCardView(card: item) }
                )
            }
            .listRowInsets(.init(top: 0, leading: 16.scale, bottom: 0, trailing: 16.scale))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            if !viewModel.isFinished {
                LoaderView(type: .pagination)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear(perform: viewModel.loadMore)
            }
        }
        .listRowSpacing(16.scale)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .safeAreaInset(edge: .bottom, content: {
            Color.clear.frame(height: ScreenSize.isIphoneXFamily ? 32.scale : 12.scale)
        })
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
    }
}
