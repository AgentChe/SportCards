//
//  SearchView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 25.10.2024.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: NavigationManager
    @Binding var searchText: String
    @Binding var isFocused: Bool
    @Binding var filters: Filters
    
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
            
            SearchField(searchText: $searchText, isFocused: $isFocused)
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

#Preview {
    SearchView(searchText: .constant(""), isFocused: .constant(false), filters: .constant(.init()))
}
