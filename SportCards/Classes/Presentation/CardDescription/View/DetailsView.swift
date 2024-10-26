//
//  DetailsView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import SwiftUI

struct DetailsView: View {
    let details: [CardDetails.Detail]
    
    var body: some View {
        Grid(verticalSpacing: 12.scale) {
            ForEach(details, id: \.self) { item in
                GridRow {
                    Text(item.name)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.white.opacity(0.5))
                        .gridColumnAlignment(.leading)
                    Spacer()
                    Text(item.value)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.white)
                        .gridColumnAlignment(.trailing)
                }
            }
        }
        .padding(16.scale)
        .background(.main300, in: RoundedRectangle(cornerRadius: 8.scale))
    }
}

#Preview {
    DetailsView(details: [])
}
