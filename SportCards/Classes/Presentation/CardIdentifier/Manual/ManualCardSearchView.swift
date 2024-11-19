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
    @StateObject private var viewModel = CardSearchViewModel()
    
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
        .scrollDismissesKeyboard(.immediately)
        .screenState($viewModel.screenState, tryAgain: viewModel.retry)
        .manualSearchable(searchText: $viewModel.searchText, filters: $viewModel.filters)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) { Image("Back") }
            }
        }
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom, content: {
            Color.clear.frame(height: 32.scale)
        })
        .gradientBackground()
    }
}

#Preview {
    NavigationStack {
        ManualCardSearchView()
    }
}
