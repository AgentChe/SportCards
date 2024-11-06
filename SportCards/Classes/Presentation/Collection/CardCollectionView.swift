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
            if viewModel.isAvailable {
                PageTabBar(tabs: CollectionTab.allCases, selectedTab: $currentTab)
                TabView(selection: $currentTab) {
                    ScannedListView()
                        .tag(CollectionTab.scanned)
                    WishListView()
                        .tag(CollectionTab.wishList)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            } else {
                CardCollectionEmptyView()
            }
        }
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.makeData)
        .gradientBackground()
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

#Preview {
    CardCollectionView()
}
