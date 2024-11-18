//
//  CollectionSettingsView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 07.10.2024.
//

import SwiftUI

struct CollectionSettingsView: View {
    @EnvironmentObject var router: NavigationManager
    @Binding var currentLayout: CollectionLayoutType
    @Binding var filters: Filters
    
    var body: some View {
        HStack(spacing: 10.scale) {
            Text("Display")
                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                .foregroundStyle(.mono100.opacity(0.5))
            
            ForEach(CollectionLayoutType.allCases, id: \.self) { layout in
                Button(action: { withAnimation { currentLayout = layout } }) {
                    Image(layout == currentLayout ? layout.selectedIcon : layout.defaultIcon)
                        .resizable()
                        .frame(width: 24.scale, height: 24.scale)
                }
                .background(
                    layout == currentLayout ? .black : .clear,
                    in: RoundedRectangle(cornerRadius: 4.scale)
                )
            }
            
            Spacer()
            
            
            Button(action: { router.push(to: Route.filters($filters)) }) {
                HStack(spacing: 10.scale) {
                    Image("Collection.Filters")
                        .resizable()
                        .frame(width: 24.scale, height: 24.scale)
                    
                    Text("Filters")
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                        .foregroundStyle(.mono100.opacity(0.5))
                }
            }
        }
        .padding(.vertical, 12.scale)
        .padding(.horizontal, 16.scale)
        .background(.main300, in: Capsule())
    }
}

#Preview {
    VStack {
        CollectionSettingsView(currentLayout: .constant(.list), filters: .constant(.init()))
        Spacer()
    }
    .padding(.horizontal, 16.scale)
    .background(.black)
}

private extension CollectionLayoutType {
    var defaultIcon: String {
        switch self {
        case .list:
            "Collection.List.Default"
        case .grid:
            "Collection.Grid.Default"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .list:
            "Collection.List.Selected"
        case .grid:
            "Collection.Grid.Selected"
        }
    }
}
