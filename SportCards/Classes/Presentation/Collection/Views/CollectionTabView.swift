//
//  CollectionTabView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 07.10.2024.
//

import SwiftUI

struct CollectionTabView: View {
    @Binding var selectedTab: CollectionTab
    var body: some View {
        HStack {
            ForEach(CollectionTab.allCases, id: \.self) { tab in
                Button(
                    action: {
                        withAnimation { selectedTab = tab }
                    }, 
                    label: {
                        HStack {
                            Spacer()
                            Text(tab.name)
                                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                                .foregroundStyle(tab == selectedTab ? .white : .white.opacity(0.5))
                                .padding(.vertical, 8.scale)
                            Spacer()
                        }
                        .overlay(alignment: .bottom) {
                            if selectedTab == tab {
                                Rectangle()
                                    .fill(.main100)
                                    .frame(height: 2.scale)
                            }
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    VStack {
        CollectionTabView(selectedTab: .constant(.scanned))
        Spacer()
    }
    .background(.black)
}

private extension CollectionTab {
    var name: String {
        switch self {
        case .scanned:
            "Collection.Tab.Scanned".localized
        case .wishList:
            "Collection.Tab.WishList".localized
        }
    }
}
