//
//  PageTabBar.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import SwiftUI

protocol TabItemProtocol: Hashable {
    var name: String { get }
}

struct PageTabBar<Tab: TabItemProtocol>: View {
    private let tabs: [Tab]
    @Binding private var selectedTab: Tab
    @Namespace private var animation
    
    init(tabs: [Tab], selectedTab: Binding<Tab>) {
        self.tabs = tabs
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Button(
                    action: { withAnimation { selectedTab = tab } },
                    label: {
                        Text(tab.name)
                            .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                            .foregroundStyle(tab == selectedTab ? .white : .white.opacity(0.5))
                            .padding(.vertical, 8.scale)
                            .frame(maxWidth: .infinity)
                            .overlay(selector(for: tab), alignment: .bottom)
                    }
                )
            }
        }
    }
}

private extension PageTabBar {
    @ViewBuilder
    func selector(for tab: Tab) -> some View {
        if selectedTab == tab {
            Rectangle()
                .fill(.main100)
                .frame(height: 2.scale)
                .matchedGeometryEffect(id: "PageTabBar", in: animation)
        }
    }
}

#Preview {
    @State var selected: CollectionTab = .wishList
    return VStack {
        PageTabBar(tabs: CollectionTab.allCases, selectedTab: $selected)
        Spacer()
    }
    .background(.black)
}
