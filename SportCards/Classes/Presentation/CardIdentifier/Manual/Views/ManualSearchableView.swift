//
//  ManualSearchableView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import SwiftUI

extension View {
    func manualSearchable(searchText: Binding<String>, filters: Binding<Filters>) -> some View {
        modifier(SearchableModifier(searchText: searchText, filters: filters))
    }
}

private struct SearchableModifier: ViewModifier {
    @State private var isFocused: Bool = false
    @Binding private var searchText: String
    @Binding private var filters: Filters
    
    private let animation: AnyTransition = .scale.combined(with: .offset(y: -100.scale)).combined(with: .opacity)
    
    init(searchText: Binding<String>, filters: Binding<Filters>) {
        self._searchText = searchText
        self._filters = filters
    }
    
    func body(content: Content) -> some View {
        let isSearch = isFocused || !searchText.isEmpty || filters.count > 0
        
        VStack(spacing: 0) {
            if !isSearch {
                header
                    .transition(animation)
                    .padding(.init(top: 4.scale, leading: 28.scale, bottom: 30.scale, trailing: 28.scale))
            }
            
            SearchView(searchText: $searchText, isFocused: $isFocused, filters: $filters)
                .padding(.init(top: 16.scale, leading: 16.scale, bottom: 24.scale, trailing: 16.scale))
            
            content
        }
        .animation(.easeOut(duration: 0.3), value: isSearch)
    }
    
    @ViewBuilder private var header: some View {
        VStack(spacing: 16.scale) {
            Image("Scanner.Cards")
                .resizable()
                .frame(width: 150.scale, height: 150.scale)
            Text("ManualSearch.Title".localized)
                .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                .foregroundStyle(.white)
            Text("ManualSearch.Subtitle".localized)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}
