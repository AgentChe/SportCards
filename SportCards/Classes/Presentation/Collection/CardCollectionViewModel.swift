//
//  CardCollectionViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 07.10.2024.
//

import Foundation
import Combine

final class CardCollectionViewModel: ObservableObject {
    @Published var currentTab: CollectionTab = .scanned
    @Published var cards: [CardDiscover] = []
    
    private lazy var profileManager = ProfileManager()
    
    init() {
        cards = makeTestDataSource()
    }
    
    private func makeTestDataSource() -> [CardDiscover] {
        return [
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
        
    }
}
