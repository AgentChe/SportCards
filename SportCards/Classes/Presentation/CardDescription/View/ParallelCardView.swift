//
//  ParallelCardView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import SwiftUI
import NukeUI

struct ParallelCardView: View {
    let model: CardDiscover
    
    var body: some View {
        HStack(spacing: 0) {
            LazyImage(source: model.imageURL) { state in
                if let image = state.image {
                    image
                        .resizingMode(.aspectFill)
                        .clipShape(RoundedRectangle(cornerRadius: 6.scale))
                } else {
                    RoundedRectangle(cornerRadius: 6.scale)
                        .fill(.main200)
                }
            }
            .frame(width: 60.scale, height: 87.scale)
            .padding(.trailing, 20.scale)
            
            VStack(alignment: .leading, spacing: 8.scale) {
                Text(model.title)
                    .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
                    .lineLimit(1)
                    .foregroundStyle(.mono100)
                
                Text(model.subtitle)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    .lineLimit(1)
                    .foregroundStyle(.mono100.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 8.scale, leading: 21.scale, bottom: 8.scale, trailing: 16.scale))
        .background(.main300, in: RoundedRectangle(cornerRadius: 12.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 12.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}

#Preview {
    ParallelCardView(model: CardDiscover.mock.first!)
}
