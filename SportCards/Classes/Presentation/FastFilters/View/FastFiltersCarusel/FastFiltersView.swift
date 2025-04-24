//
//  FastFiltersView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.04.2025.
//

import SwiftUI

struct FastFiltersView: View {
    @Binding var filters: Filters
    @State private var selected: FastFilterType?
    
    var body: some View {
        HStack(spacing: 12.scale) {
            ForEach(FastFilterType.allCases) { item in
                Button(
                    action: { selected = item },
                    label: {
                        Text(item.title)
                            .font(Fonts.Inter.font(size: 14.scale, weight: .w700))
                            .foregroundStyle(Appearance.mono100)
                            .padding(.vertical, 8.scale)
                            .padding(.horizontal, 14.scale)
                            .background(.main300, in: Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(.main200, lineWidth: 1.scale)
                            }
                    }
                )
                .overlay(alignment: .topTrailing) {
                    counterOverlay(for: filters.count(for: item))
                        .alignmentGuide(.trailing) {
                            $0[.trailing] - 3.scale
                        }
                        .alignmentGuide(.top) {
                            $0[.top] + 5.scale
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $selected) { FastFiltersSheet(type: $0, filters: $filters) }
    }
    
    @ViewBuilder
    func counterOverlay(for count: Int) -> some View {
        if count > 0 {
            Text("\(count)")
                .font(Fonts.Inter.font(size: 12.scale, weight: .w700))
                .foregroundStyle(.white)
                .frame(width: 18.scale, height: 18.scale)
                .background(.main100, in: Circle())
        }
    }
}

private extension Filters {
    func count(for fast: FastFilterType) -> Int {
        switch fast {
        case .gradingService:
            return gradeService.count
        case .grade:
            return gradeValues.count
        case .category:
            return category.count
        }
    }
}
