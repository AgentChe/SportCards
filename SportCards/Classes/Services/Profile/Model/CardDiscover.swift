//
//  CardDiscover.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

struct CardDiscover: Equatable, Hashable {
    let cardId: String
    let imageURL: URL?
    let title: String
    let subtitle: String
    let grade: String
    let currentPrice: String
    let currentPriceRaw: Double
    let collectionName: String?
}

extension CardDiscover: Identifiable {
    var id: String { cardId + grade }
}

extension CardDiscover: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
        case title
        case subtitle
        case grade
        case currentPrice = "current_price"
        case currentPriceRaw = "current_price_raw"
        case collectionName = "collection_name"
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        cardId = try containter.decode(String.self, forKey: .id)
        imageURL = try? containter.decodeIfPresent(URL.self, forKey: .imageURL)
        title = try containter.decode(String.self, forKey: .title)
        subtitle = try containter.decode(String.self, forKey: .subtitle)
        grade = try containter.decode(String.self, forKey: .grade)
        currentPrice = try containter.decode(String.self, forKey: .currentPrice)
        currentPriceRaw = try containter.decode(Double.self, forKey: .currentPriceRaw)
        collectionName = try? containter.decode(String.self, forKey: .collectionName)
    }
}

extension CardDiscover {
    static let mock: [CardDiscover] = [
        .init(
            cardId: "2",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "John Smoltz",
            subtitle: "Topps",
            grade: "PSA",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            cardId: "1",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "PSA",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            cardId: "3",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: "RAW",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            cardId: "4",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "RAW",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            cardId: "5",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: "PSA",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            cardId: "6",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "PSA",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            cardId: "7",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: "RAW",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        )
    ]
}
