//
//  WishListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import SwiftUI

struct WishListView: View {
    @StateObject private var viewModel = CollectionViewModel(tab: .wishList)
    @State private var layout: CollectionLayoutType = .list
    
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
                    ForEach(viewModel.cards, id: \.id) { card in
                        switch layout {
                        case .list:
                            RecommendedCardView(card: card)
                        case .grid:
                            CardGridView(card: card)
                        }
                    }
                }
                .padding(.horizontal, 16.scale)
                .padding(.bottom, 32.scale)
            }
        }
        .overlay {
            if viewModel.cards.isEmpty {
                VStack(spacing: 16.scale) {
                    Spacer()
                    Image("Onboarding4")
                        .resizable()
                        .frame(width: 150.scale, height: 150.scale)
                    Text("Collection.Empty.Title".localized)
                        .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                        .foregroundStyle(.mono100)
                    Text("Collection.Empty.Subtitle".localized)
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                        .foregroundStyle(.mono100.opacity(0.5))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(.black)
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    WishListView()
}
