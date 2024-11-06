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
    @State private var filters: Filters = .init()
    @State private var searchText: String = ""
    
    @Namespace private var animation
    
    func body(content: Content) -> some View {
        VStack {
            SearchView(searchText: $searchText, isFocused: $isFocused, filters: $filters)
                .padding(.init(top: 14.scale, leading: 16.scale, bottom: 24.scale, trailing: 16.scale))
            
            if isFocused || !searchText.isEmpty {
                HomeSearchView(searchText: $searchText, filters: $filters)
                    .matchedGeometryEffect(id: "SEARCH", in: animation)
            } else {
                content
                    .matchedGeometryEffect(id: "LIST", in: animation)
            }
        }
    }
}

private struct HomeSearchView: View {
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel = CardSearchViewModel()
    
    @Binding var searchText: String
    @Binding var filters: Filters
    
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
            Color.clear.frame(height: 32.scale)
        })
        .onChange(of: filters) { viewModel.filters = $0 }
        .onChange(of: searchText) { viewModel.searchText = $0 }
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
    }
}
