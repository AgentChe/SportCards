//
//  CardGridView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI
import NukeUI

struct CardGridView: View {
    let card: CardDiscover
    var body: some View {
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
        .aspectRatio(0.7, contentMode: .fill)
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
            currentPrice: "$954 - $1,234",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            id: "4",
            imageURL: URL(string: "https://sportscards.com/cdn/shop/products/90740-1_2000x.jpg?v=1679610183"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: .raw,
            currentPrice: "$954 - $1,234",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        )
    ]
    
    return ScrollView(.vertical) {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 17.5.scale), .init(.flexible(), spacing: 17.5.scale)], spacing: 16.scale) {
            ForEach(items, id: \.id) {
                CardGridView(card: $0)
            }
        }
        .padding(.horizontal, 16.scale)
    }
    .background(.black)
}
