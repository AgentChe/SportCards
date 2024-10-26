//
//  TabBarView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 02.10.2024.
//

import SwiftUI

struct TabBarView<Content: View>: View {
    
    @Binding private var selected: MainTabType
    private var content: Content
    private let items: [MainTabType]
    
    init(items: [MainTabType], selected: Binding<MainTabType>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.items = items
        self._selected = selected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                content
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 100.scale) {
                ForEach(items, id: \.self) { item in
                    Button(
                        action: { withAnimation { selected = item } },
                        label: {
                            Image(selected == item ? item.selectedIcon : item.defaultIcon)
                                .frame(width: 40.scale, height: 40.scale)
                        }
                    )
                    .padding(.bottom, ScreenSize.isIphoneXFamily ? 36.scale : 16.scale)
                    if item != items.last {
                        Spacer()
                    }
                }
            }
            .padding(.top, 18.scale)
            .padding(.horizontal, 54.scale)
            .background(.main300)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24.scale, topTrailingRadius: 24.scale))
            .overlay {
                UnevenRoundedRectangle(topLeadingRadius: 24.scale, topTrailingRadius: 24.scale)
                    .stroke(.main200, lineWidth: 1.scale)
            }
            .overlay(alignment: .top) {
                NavigationLink(value: Route.cardIdetifier) {
                    Image("Home.Scanner")
                        .padding(22.scale)
                        .background(.main100, in: Circle())
                }
                .alignmentGuide(.top, computeValue: { dimension in
                    dimension[.top] + 22.scale
                })
            }
        }
        .ignoresSafeArea(edges: [.bottom])
    }
}

#Preview {
    TabBarView(items: MainTabType.allCases, selected: .constant(.home)) {
        Color.purple
    }
}

private extension MainTabType {
    var selectedIcon: String {
        switch self {
        case .home:
            "Home.Selected"
        case .collection:
            "Collection.Selected"
        }
    }
    
    var defaultIcon: String {
        switch self {
        case .home:
            "Home.Default"
        case .collection:
            "Collection.Default"
        }
    }
}
