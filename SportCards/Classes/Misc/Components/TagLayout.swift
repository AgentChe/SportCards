//
//  TagLayout.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct TagLayout: Layout {
    var spacing: CGFloat = .zero
    var alignment: HorizontalAlignment = .center
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? .infinity
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        
        return layout(sizes: sizes, spacing: spacing, containerWidth: containerWidth).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let offsets = layout(sizes: sizes, spacing: spacing, containerWidth: bounds.width).offsets
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: .init(x: offset.x + bounds.minX, y: offset.y + bounds.minY), proposal: proposal)
        }
    }
    
    private func layout(sizes: [CGSize], spacing: CGFloat = 8, containerWidth: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var currentLine: [CGSize] = []
        
        var currentPosition: CGPoint = .zero
        
        var lineHeight: CGFloat = 0
        
        var maxX: CGFloat = 0
        
        func correctedOffset() {
            var startX: CGFloat = .zero
            switch alignment {
            case .trailing:
                let allWidth = currentLine
                    .reduce(into: 0) { $0 += $1.width + spacing } - spacing
                startX = containerWidth - allWidth
            case .center:
                let allWidth = currentLine
                    .reduce(into: 0) { $0 += $1.width + spacing } - spacing
                startX = (containerWidth - allWidth) / 2
            default:
                break
            }
            
            currentLine.forEach { size in
                result.append(.init(x: startX, y: currentPosition.y))
                startX += size.width
                startX += spacing
            }
            
            currentPosition.x = 0
            currentPosition.y += lineHeight + spacing
            lineHeight = 0
            currentLine = []
        }
     
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                correctedOffset()
            }
            
            currentLine.append(size)
            currentPosition.x += size.width
            
            maxX = max(maxX, currentPosition.x)
            currentPosition.x += spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        if !currentLine.isEmpty {
            correctedOffset()
        }
        return (result,
                .init(width: maxX, height: currentPosition.y + lineHeight))
    }
}

#Preview {
    TagLayout(spacing: 16.scale, alignment: .trailing) {
        ForEach(Game.allCases, id: \.self) { item in
            TagView(item.name, isSelected: false)
        }
    }
}
