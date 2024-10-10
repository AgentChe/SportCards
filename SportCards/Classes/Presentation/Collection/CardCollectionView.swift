//
//  CardCollectionView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import SwiftUI

struct CardCollectionView: View {
    @State private var currentTab: CollectionTab = .scanned
    
    var body: some View {
        VStack {
            CollectionTabView(selectedTab: $currentTab)
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

import NukeUI

#Preview {
    CardCollectionView()
}
