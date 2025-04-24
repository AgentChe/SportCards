//
//  SearchView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 25.10.2024.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: NavigationManager
    @Binding private var searchText: String
    @Binding var filters: Filters
    private var isFocused: FocusState<Bool>.Binding
    
    init(searchText: Binding<String>, isFocused: FocusState<Bool>.Binding, filters: Binding<Filters>) {
        self._searchText = searchText
        self.isFocused = isFocused
        self._filters = filters
    }
    
    var body: some View {
        let isExpanded = searchText.count >= 3
        ZStack(alignment: .trailing) {
            Button(action: { router.push(to: Route.filters($filters)) }) {
                Image("Home.Settings")
                    .frame(width: 50.scale, height: 50.scale)
                    .background(.main300, in: Circle())
            }
            .overlay(counterOverlay, alignment: .topTrailing)
            .opacity(isExpanded ? 1 : 0)
            
            SearchField(searchText: $searchText, isFocused: isFocused)
                .padding(.trailing, isExpanded ? 66.scale : 0)
        }
        .onChange(of: searchText) { value in
            if value.count < 3 {
                filters = .init()
            }
        }
        .animation(.default, value: isExpanded)
    }
}

private extension SearchView {
    @ViewBuilder
    var counterOverlay: some View {
        if filters.count > 0 {
            Text("\(filters.count)")
                .font(Fonts.Inter.font(size: 12.scale, weight: .w700))
                .foregroundStyle(.white)
                .padding(6.scale)
                .background(.main100, in: Circle())
                .offset(y: -10.scale)
        }
    }
}
