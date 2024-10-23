//
//  RecommendedCardView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import SwiftUI
import NukeUI

struct RecommendedCardView: View {
    let card: CardDiscover
    var body: some View {
        HStack(spacing: 16.scale) {
            LazyImage(source: card.imageURL) { state in
                if let image = state.image {
                    image
                        .resizingMode(.aspectFill)
                        .clipShape(RoundedRectangle(cornerRadius: 8.scale))
                } else {
                    RoundedRectangle(cornerRadius: 8.scale)
                        .fill(.main200)
                }
            }
            .frame(width: 83.scale, height: 120.scale)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 6.scale) {
                    VStack(alignment: .leading, spacing: 6.scale) {
                        Text(card.title)
                            .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
                            .foregroundStyle(.mono100)
                        Text(card.subtitle)
                            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                            .foregroundStyle(.mono100.opacity(0.5))
                    }
                    Spacer()
                    
                    Text(card.grade)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.mono100)
                        .padding(.horizontal, 16.5.scale)
                        .padding(.vertical, 8.scale)
                        .background(.main200, in: Capsule())
                        .padding(.trailing, 6.scale)
                }
                
                Spacer()
                    .frame(maxHeight: 27.scale)
                
                Text("Home.Approximate".localized)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    .foregroundStyle(.mono100.opacity(0.5))
                    .padding(.bottom, 10.scale)
                Text(card.currentPrice)
                    .font(Fonts.Inter.font(size: 20.scale, weight: .w700))
                    .foregroundStyle(.mono100)
            }
            .lineLimit(1)
            
            
        }
        .padding(10.scale)
        .background(.main300, in: RoundedRectangle(cornerRadius: 12.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 12.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}

#Preview {
    ScrollView(.vertical) {
        LazyVStack(spacing: 16.scale) {
            ForEach(CardDiscover.mock) {
                RecommendedCardView(card: $0)
            }
        }
        .padding(.horizontal, 16.scale)
    }
    .background(.black)
}
