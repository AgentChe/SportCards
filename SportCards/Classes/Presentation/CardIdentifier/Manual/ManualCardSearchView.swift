//
//  ManualCardSearchView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 18.10.2024.
//

import SwiftUI

struct ManualCardSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel = ManualCardSearchViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.elements) { item in
                Button(
                    action: { router.push(to: .cardDescription) },
                    label: { RecommendedCardView(card: item) }
                )
            }
            .listRowInsets(.init(top: 0, leading: 16.scale, bottom: 0, trailing: 16.scale))
            .listRowBackground(Color.clear)
            
            if !viewModel.isFinished {
                footer
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear(perform: viewModel.loadMore)
            }
        }
        .listRowSpacing(16.scale)
        .listRowSeparator(.hidden)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .searchable(searchText: $viewModel.searchText, filters: $viewModel.filters)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) { Image("Back") }
            }
        }
        .gradientBackground()
    }
    
    @ViewBuilder private var footer: some View {
        HStack {
            Spacer()
            ProgressView()
                .frame(width: 40.scale, height: 40.scale)
                .progressViewStyle(.sportCards)
                .foregroundStyle(.white)
            Spacer()
        }
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
        VStack(spacing: 0) {
            let isCollapsed = !(isFocused || !searchText.isEmpty || filters.count > 0 )
            
            if isCollapsed {
                header
                    .transition(animation)
                    .padding(.init(top: 4.scale, leading: 28.scale, bottom: 30.scale, trailing: 28.scale))
            }
            
            SearchView(searchText: $searchText, isFocused: $isFocused, filters: $filters)
                .padding(.init(top: 16.scale, leading: 16.scale, bottom: 24.scale, trailing: 16.scale))
            
            content
        }
        .animation(.easeOut, value: isFocused)
        .animation(.easeOut, value: searchText.isEmpty)
        .animation(.easeOut, value: filters.count == 0)
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

private extension View {
    func searchable(searchText: Binding<String>, filters: Binding<Filters>) -> some View {
        modifier(SearchableModifier(searchText: searchText, filters: filters))
    }
}

#Preview {
    NavigationStack {
        ManualCardSearchView()
    }
}
