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
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = CardSearchViewModel()
    
    func body(content: Content) -> some View {
        let isSearch = isFocused || !viewModel.searchText.isEmpty
        let isVisibleFastFilters = viewModel.searchText.count >= 3
        
        VStack(spacing: 24.scale) {
            SearchView(searchText: $viewModel.searchText, isFocused: $isFocused, filters: $viewModel.filters)
                .padding(.horizontal, 16.scale)
            
            if isSearch {
                if isVisibleFastFilters {
                    FastFiltersView(filters: $viewModel.filters)
                        .padding(.horizontal, 16.scale)
                }
                
                HomeSearchView(viewModel: viewModel)
                    .overlay(overlayView)
            } else {
                content
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isVisibleFastFilters)
        .animation(.easeInOut, value: isSearch)
        .padding(.top, 14.scale)
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
