//
//  CardDiscover.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

struct CardDiscover: Equatable, Hashable {
    let id: String
    let imageURL: URL?
    let title: String
    let subtitle: String
    let grade: String
    let currentPrice: String
    let currentPriceRaw: Double
    let collectionName: String?
}

extension CardDiscover {
    init?(from body: [String: Any]) {
        guard
            let id = body["id"] as? String,
            let title = body["title"] as? String,
            let subtitle = body["subtitle"] as? String,
            let grade = body["grade"] as? String,
            let currentPrice = body["current_price"] as? String,
            let currentPriceRaw = body["current_price_raw"] as? Double
        else { return nil }
        
        self.id = id
        self.imageURL = (body["image"] as? String).flatMap { URL(string: $0) }
        self.title = title
        self.subtitle = subtitle
        self.grade = grade
        self.currentPrice = currentPrice
        self.currentPriceRaw = currentPriceRaw
        self.collectionName = body["collection_name"] as? String
    }
    
    static func map(response: Any) -> [CardDiscover] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { CardDiscover(from: $0) }
    }
}

extension CardDiscover {
    static let mock: [CardDiscover] = [
        .init(
            id: "2",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "John Smoltz",
            subtitle: "Topps",
            grade: "PSA",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            id: "1",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "PSA",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            id: "3",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: "RAW",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            id: "4",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "RAW",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            id: "5",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
            title: "Smoltz John Smoltz Chamberlain",
            subtitle: "Topps",
            grade: "PSA",
            currentPrice: "$249.99",
            currentPriceRaw: 249.99,
            collectionName: "Finest"
        ),
        .init(
            id: "6",
            imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
            title: "Wilt Chamberlain Smoltz",
            subtitle: "Fleer Basketball",
            grade: "PSA",
            currentPrice: "$5499.99",
            currentPriceRaw: 5499.99,
            collectionName: nil
        ),
        .init(
            id: "7",
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
