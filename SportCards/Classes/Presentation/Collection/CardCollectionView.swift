//
//  CardCollectionView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import SwiftUI

struct CardCollectionView: View {
    @StateObject private var viewModel = CardCollectionViewModel()
    @State private var currentTab: CollectionTab = .scanned
    
    var body: some View {
        VStack {
            CollectionTabView(selectedTab: $currentTab)
                .padding(.vertical, 14.scale)
            TabView(selection: $currentTab) {
                ScannedListView()
                    .tag(CollectionTab.scanned)
                WishListView()
                    .tag(CollectionTab.wishList)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(.black)
    }
}

extension CollectionLayoutType {
    var columns: [GridItem] {
        switch self {
        case .list:
            [GridItem(.flexible())]
        case .grid:
            [GridItem(.flexible(), spacing: 17.5.scale), .init(.flexible(), spacing: 17.5.scale)]
        }
    }
}

struct CardGridView: View {
    let card: CardDiscover
    var body: some View {
        AsyncImage(url: card.imageURL) { image in
            image
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 8.scale))
        } placeholder: {
            RoundedRectangle(cornerRadius: 8.scale)
                .fill(.main200)
        }
    }
}

#Preview {
    CardCollectionView()
}
