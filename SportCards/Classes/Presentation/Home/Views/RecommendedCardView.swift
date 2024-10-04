//
//  RecommendedCardView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import SwiftUI

struct RecommendedCardView: View {
    let card: CardDiscover
    var body: some View {
        HStack(spacing: 16.scale) {
            AsyncImage(url: card.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 83.scale, height: 120.scale)
                    .clipShape(RoundedRectangle(cornerRadius: 8.scale))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8.scale)
                    .fill(.main200)
                    .frame(width: 83.scale, height: 120.scale)
            }
            
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
                    
                    Text(card.grade.shortName ?? "")
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.mono100)
                        .padding(.horizontal, 16.5.scale)
                        .padding(.vertical, 8.scale)
                        .background(.main200, in: Capsule())
                        .padding(.trailing, 6.scale)
                }
                
                Spacer()
                
                Text("Approximate estimate")
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
                .stroke(lineWidth: 1.scale)
                .fill(.main200)
        }
    }
}

#Preview {
    let items: [CardDiscover] = [
        .init(
            id: "2",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "John Smoltz",
            subtitle: "Topps",
            grade: .psa,
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            id: "1",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: .psa,
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            id: "3",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: .raw,
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        )
    ]
    
    return ScrollView(.vertical) {
        LazyVStack(spacing: 16.scale) {
            ForEach(items, id: \.id) {
                RecommendedCardView(card: $0)
            }
        }
        .padding(.horizontal, 16.scale)
    }
    .background(.black)
}
