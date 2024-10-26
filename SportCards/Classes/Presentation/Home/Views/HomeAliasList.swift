//
//  HomeAliasList.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import SwiftUI

struct HomeAliasList: View {
    private let alias: [CardCategory]
    private let action: (CardCategory) -> Void
    
    init(alias: [CardCategory], action: @escaping (CardCategory) -> Void) {
        self.alias = alias
        self.action = action
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HomeAliasLayout {
                ForEach(alias, id: \.self) { item in
                    Button(
                        action: { action(item) },
                        label: {
                            Text(item.name)
                                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                                .foregroundStyle(.mono100)
                                .padding(.horizontal, 16.scale)
                                .padding(.vertical, 8.scale)
                                .background(.main300, in: Capsule())
                                .overlay {
                                    Capsule()
                                        .stroke(.main200, lineWidth: 1.scale)
                                }
                        }
                    )
                    .gridColumnAlignment(.leading)
                }
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    ScrollView(.vertical) {
        Spacer()
            .frame(height: 300.scale)
        HomeAliasList(alias: [], action: { _ in })
            .padding(.leading, 16.scale)
    }
    .background(.black)
}

struct HomeAliasLayout: Layout {
    
    var horizontalSpacing: CGFloat = 12.scale
    var verticalSpacing: CGFloat = 12.scale
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        return layoutSize(sizes: sizes).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let offsets = layoutSize(sizes: sizes).offsets
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: .init(x: offset.x + bounds.minX, y: offset.y + bounds.minY), proposal: proposal)
        }
    }
    
    private func layoutSize(sizes: [CGSize]) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var maxX: CGFloat = .zero
        var maxY: CGFloat = .zero
        var firstPosition: CGPoint = .zero
        var secondPosition: CGPoint = .zero
        
        for size in sizes {
            if firstPosition.x <= secondPosition.x {
                result.append(.init(x: firstPosition.x, y: firstPosition.y))
                firstPosition.x += size.width
                secondPosition.y = size.height + verticalSpacing
                maxX = max(maxX, firstPosition.x)
                firstPosition.x += horizontalSpacing
            } else {
                result.append(.init(x: secondPosition.x, y: secondPosition.y))
                secondPosition.x += size.width
                maxX = max(maxX, secondPosition.x)
                maxY = max(maxY, secondPosition.y + size.height)
                secondPosition.x += horizontalSpacing
            }
        }
        
        return (result, .init(width: maxX, height: maxY) )
    }
}
